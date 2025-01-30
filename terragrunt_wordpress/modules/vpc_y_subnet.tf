data "aws_vpc" "existing_vpc" {
  id = var.vpc_id
}

data "aws_subnets" "fetch_subnet" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
}

#---------------------------------------------------------------------------------------
# data "aws_subnets" "public_subnet_1" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.existing_vpc.id]
#   }
#   tags = {
#     Name = "public-subnet-1"
#   }
# }

# data "aws_subnets" "public_subnet_2" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.existing_vpc.id]
#   }
#   tags = {
#     Name = "public-subnet-2"
#   }
# }

# data "aws_subnets" "public_subnet_3" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.existing_vpc.id]
#   }
#   tags = {
#     Name = "public-subnet-3"
#   }
# }
#-----------------------------------------------------------------------------

# data "aws_subnets" "private_subnet" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.existing_vpc.id]
#   }
#   tags = {
#     Name = ["private-subnet-1", "private-subnet-2"]
#   }
# }

# data "aws_subnet" "private_subnet_id" {
#   for_each = toset(data.aws_subnets.example.ids)
#   id       = each.value
# }

# El codigo de abajo ha sido comentado por que en vez de crear una nueva VPC, all llegar al limite, tengo que cambiar el codigo para usar una ya existente.

# resource "aws_vpc" "new_vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name = "new-vpc-dad"
#   }
# }

# # Public Subnets
# resource "aws_subnet" "public_subnet_1" {
#   vpc_id            = aws_vpc.new_vpc.id
#   cidr_block        = "10.0.1.0/24"  
#   availability_zone = "eu-west-3a"    
#   map_public_ip_on_launch = true  
#   tags = {
#     Name = "public-subnet-1"
#   }
# }

# resource "aws_subnet" "public_subnet_2" {
#   vpc_id            = aws_vpc.new_vpc.id
#   cidr_block        = "10.0.2.0/24"  
#   availability_zone = "eu-west-3b"     
#   map_public_ip_on_launch = true  
#   tags = {
#     Name = "public-subnet-2"
#   }
# }

# # Private Subnets
# resource "aws_subnet" "private_subnet_1" {
#   vpc_id            = aws_vpc.new_vpc.id
#   cidr_block        = "10.0.3.0/24"  
#   availability_zone = "eu-west-3a"     
#   map_public_ip_on_launch = false  
#   tags = {
#     Name = "private-subnet-1"
#   }
# }

# resource "aws_subnet" "private_subnet_2" {
#   vpc_id            = aws_vpc.new_vpc.id
#   cidr_block        = "10.0.4.0/24"  
#   availability_zone = "eu-west-3b"     
#   map_public_ip_on_launch = false  
#   tags = {
#     Name = "private-subnet-2"
#   }
# }