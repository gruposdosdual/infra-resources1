
/*
terraform { 
 backend "network" { 
  bucket = "test-bucket-43120896345235"
  key    = "subnet/terraform.tfstate"
  region = "eu-west-3" 
 }
}
*/

/*
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

*/

# Módulo de subredes
resource "aws_subnet" "subnet_1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block_1
  availability_zone = "eu-west-3a"
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block_2
  availability_zone = "eu-west-3b"
}

output "subnet_ids" {
  value = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
}




