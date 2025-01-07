resource "aws_subnet" "this" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block

  tags = {
    Name = "main-subnet"
  }
}

output "subnet_id" {
  value = aws_subnet.this.id
}
