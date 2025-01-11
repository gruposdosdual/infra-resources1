provider "aws" {
  region  = "eu-west-3"
  profile = "248189943700_EKS-alumnos"
}

# VPC y componentes de red
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true  # Importante para RDS
  enable_dns_support   = true  # Importante para RDS

  tags = {
    Name = "VPC-jgl"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Internet Gateway-jgl"
  }
}

# Subnets para RDS (necesitamos al menos 2 para Multi-AZ)
resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-1-jgl"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-2-jgl"
  }
}

# Grupo de subnets para RDS
resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "mysql-subnet-group"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = {
    Name = "MySQL DB subnet group"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Route Table-jgl"
  }
}

resource "aws_route_table_association" "route_table_association_1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.route_table.id
}

# Security Groups
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_mysql" {
  name        = "allow_mysql"
  description = "Allow MySQL inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_ssh.id]  # Permite conexiones desde las instancias EC2
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow MySQL"
  }
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami           = "ami-09be70e689bddcef5"
  instance_type = "t2.micro"
  key_name      = "my-aws-key"
  subnet_id     = aws_subnet.subnet_1.id

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  associate_public_ip_address = true

  depends_on = [aws_security_group.allow_ssh]

  tags = {
    Name = "WebServer-Terraform-FJGL"
  }
}

# RDS Instance
resource "aws_db_instance" "mysql_db" {
  allocated_storage      = 20
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t4g.micro"
  db_name               = "mydb"
  username              = "admin"
  password              = "password123"
  publicly_accessible   = true
  skip_final_snapshot   = true
  db_subnet_group_name  = aws_db_subnet_group.mysql_subnet_group.name
  vpc_security_group_ids = [aws_security_group.allow_mysql.id]

  tags = {
    Name = "MySQL-Terraform-FJGL"
  }
}

# Provisioner
resource "null_resource" "provision_file" {
  depends_on = [aws_instance.web_server]

  provisioner "file" {
    source      = "setup.yml"
    destination = "/home/ubuntu/setup.yml"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/my-aws-key.pem")
      host        = aws_instance.web_server.public_ip
      timeout     = "5m"
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/my-aws-key.pem")
      host        = aws_instance.web_server.public_ip
      timeout     = "5m"
    }

    inline = [
      "sudo apt update",
      "sudo apt install -y ansible",
      "ansible-playbook -i 'localhost,' -c local /home/ubuntu/setup.yml"
    ]
  }
}

output "web_server_ip" {
  value = aws_instance.web_server.public_ip
}

output "db_endpoint" {
  value = aws_db_instance.mysql_db.endpoint
}