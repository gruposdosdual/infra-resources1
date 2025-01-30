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
  ami           = "ami-07db896e164bc4476"  # Use a valid AMI for your region
  instance_type = "t2.micro"
  key_name      = "provisioner_DA" 
  
  # Security group for EC2
  security_groups = [aws_security_group.ec2_sg.name] 

  tags = {
    Name = "new-ec2-instance-dad"
  }
}

# RDS Instance
resource "aws_db_instance" "my_database" {
  identifier        = "my-database-instance-dad"
  engine            = "mysql"  
  engine_version    = "8.0"  
  instance_class    = "db.t4g.micro"
  allocated_storage = 5  
  storage_type      = "gp2" 

  db_name           = "mydatabaseDAD"
  username          = "admin"  # Admin username for the DB
  password          = "password123!"  # Use a more secure password in production
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
}

# DB Subnet Group (RDS needs a subnet group to know where to launch the database)
resource "aws_db_subnet_group" "my_db_subnet_group" {
  name        = "my-db-subnet-group-dad"
  subnet_ids  = flatten([
    data.aws_subnets.public_subnet_1.ids,
    data.aws_subnets.public_subnet_2.ids,
    data.aws_subnets.public_subnet_3.ids
  ])  
  description = "Database subnet group"

  tags = {
    Name = "MyDatabaseSubnetGroup-DAD"
  }
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
