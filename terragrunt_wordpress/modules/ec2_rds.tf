# EC2 Instance


# Security Group for EC2 Instance
resource "aws_security_group" "ec2_sg" {
  vpc_id = data.aws_vpc.existing_vpc.id  # Reference the existing VPC  

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
  }

    ingress {
    from_port   = 8080  # Allow access to WordPress on port 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic on port 8080 from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
  tags = {
    Name = "security-group-wordpress-dad"
  }
}

resource "aws_instance" "new_EC2" {
  ami           = var.ami_id  # Use a valid AMI for your region
  instance_type = var.instance_type
  key_name      = var.ec2_key_name

  # Reference the first subnet from the fetched subnets
  subnet_id = data.aws_subnets.fetch_subnet.ids[0] 
  
  # Reference security group by ID (not by name)
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  # Security group for EC2
  #security_groups = [aws_security_group.ec2_sg.name] 

  tags = {
    Name = "new-ec2-instance-dad"
  }

  # Provisioner to update hosts.ini
  provisioner "local-exec" {
    # Wait until the public IP is available (ensure the EC2 instance is fully created)
    # Remove any line containing an IP address and ansible_user=ubuntu pattern
    # Append the new public IP to hosts.ini
    command = <<EOT
    until [ -n "${aws_instance.new_EC2.public_ip}" ]; do
      sleep 5
    done
    
    
    sed -i '' '/^[0-9]\{1,3\}(\.[0-9]\{1,3\})\{3\} ansible_user=ubuntu ansible_ssh_private_key_file=.\{0,\}/d' hosts.ini && \
    
    
    echo "${aws_instance.new_EC2.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./provisioner_DA.pem" >> hosts.ini
    EOT
  }
  depends_on = [aws_security_group.ec2_sg]
}


# RDS Instance
resource "aws_db_instance" "my_database" {
  identifier        = var.db_identifier
  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_storage
  storage_type      = var.db_storage_type

  db_name           = var.db_name
  username          = var.db_user  # Admin username for the DB
  password          = var.db_password  # Use a more secure password in production
  parameter_group_name = "default.mysql8.0"  # Use default for MySQL 8.0

  # Subnet group (for private subnets)
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  multi_az            = false
  publicly_accessible = false

  tags = {
    Name = "MyRDSInstance"
  }

  skip_final_snapshot       = true  # Set to true for testing only (do not delete the database without snapshot in production)
}

# Security Group for RDS Instance
resource "aws_security_group" "rds_sg" {
  vpc_id = data.aws_vpc.existing_vpc.id  # Reference the existing VPC  

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security-group-rds-dad"
  }
}

# DB Subnet Group (RDS needs a subnet group to know where to launch the database)
resource "aws_db_subnet_group" "my_db_subnet_group" {
  name        = "my-db-subnet-group-dad2"
  subnet_ids  = data.aws_subnets.fetch_subnet.ids 
  description = "Database subnet group"

  tags = {
    Name = "MyDatabaseSubnetGroup-DAD"
  }
}

# This will run ansible after the EC2 instance is created
resource "null_resource" "ansible_playbook" {
  provisioner "local-exec" {
    command = "ansible-playbook -i hosts.ini install.yaml"
    environment = {
      ANSIBLE_PRIVATE_KEY_FILE = "./provisioner_DA.pem"
    }
  }

  depends_on = [aws_instance.new_EC2]
}

# resource "aws_instance" "new_EC2" {
#   ami           = "ami-03216a20ecc5d72ee"  # Use a valid AMI for your region
#   instance_type = "t2.micro"
#   key_name      = "provisioner_DA.pem" 
  
#   # Security group for EC2
#   security_groups = [aws_security_group.ec2_sg.name]

#   tags = {
#     Name = "new-ec2-instance-dad"
#   }
# }

# # Security Group for EC2 Instance
# resource "aws_security_group" "ec2_sg" {
#   vpc_id = aws_vpc.new_vpc.id  

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"  # Allow all outbound traffic
#     cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
#   }
# }


# # RDS Instance
# resource "aws_db_instance" "my_database" {
#   identifier        = "my-database-instance-dad"
#   engine            = "mysql"  
#   engine_version    = "8.0"  
#   instance_class    = "db.t2.micro"
#   allocated_storage = 5  
#   storage_type      = "gp2" 

#   db_name           = "mydatabaseDAD"
#   username          = "admin"  # Admin username for the DB
#   password          = "password123!"  # Use a more secure password in production
#   parameter_group_name = "default.mysql8.0"  # Use default for MySQL 8.0

#   # Subnet group (for private subnets)
#   db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name

#   vpc_security_group_ids = [aws_security_group.rds_sg.id]

#   multi_az            = false
#   publicly_accessible = false

#   tags = {
#     Name = "MyRDSInstance"
#   }

#   skip_final_snapshot       = true  # Set to true for testing only (do not delete the database without snapshot in production)
# }

# # Security Group for RDS Instance
# resource "aws_security_group" "rds_sg" {
#   vpc_id = aws_vpc.new_vpc.id  

#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]  # Allow EC2 to connect to RDS from the VPC
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"  # Allow all outbound traffic
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # DB Subnet Group (RDS needs a subnet group to know where to launch the database)
# resource "aws_db_subnet_group" "my_db_subnet_group" {
#   name        = "my-db-subnet-group-dad"
#   subnet_ids  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
#   description = "Database subnet group"

#   tags = {
#     Name = "MyDatabaseSubnetGroup-DAD"
#   }
# }
