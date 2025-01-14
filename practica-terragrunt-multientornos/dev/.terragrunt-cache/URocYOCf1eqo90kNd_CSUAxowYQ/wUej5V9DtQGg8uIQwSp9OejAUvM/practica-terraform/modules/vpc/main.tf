/*

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags = {
    Name = "main-vpc"
  }
}

output "vpc_id" {
  value = aws_vpc.this.id
}
*/

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpc_name
  }
}

output "vpc_id" {
  value = aws_vpc.this.id
}
