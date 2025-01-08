/*

terraform { 
 backend "s3" { 
  bucket = "test-bucket-43120896345235"
  key    = "rds/terraform.tfstate" 
  region = "eu-west-3" 
 }
}
*/

/*
resource "aws_db_subnet_group" "this" {
  name       = "main-db-subnet-group"
  subnet_ids = [var.subnet_id]
}
*/


resource "aws_db_instance" "default" {
  allocated_storage       = 10
  db_name                 = var.db_name
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  username                = var.username
  password                = var.password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = var.vpc_security_group_ids
  skip_final_snapshot     = true
}

resource "aws_db_instance" "replica" {
  replicate_source_db     = aws_db_instance.default.id
  instance_class          = "db.t3.micro"
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = var.vpc_security_group_ids
  publicly_accessible     = false
}


resource "aws_db_subnet_group" "this" {
  name        = "main-db-subnet-group"
  subnet_ids  = var.subnet_ids
  description = "Main DB Subnet Group for RDS"
}


