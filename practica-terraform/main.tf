/*
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}
*/
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  vpc_name   = "my-vpc"  # Establecer el nombre de la VPC
}



module "subnet" {
  source                 = "./modules/subnet"
  vpc_id                 = module.vpc.vpc_id
  subnet_cidr_block_1    = "10.0.1.0/24"
  subnet_cidr_block_2    = "10.0.2.0/24"
  cidr_block             = "10.0.0.0/16" # Asegúrate de pasar el valor de esta variable si está declarada en el módulo subnet
}


module "security_group" {
  source  = "./modules/security_group"
  vpc_id  = module.vpc.vpc_id
}

module "rds" {
  source                 = "./modules/rds"
  subnet_ids             = module.subnet.subnet_ids
  vpc_security_group_ids = [module.security_group.sg_id]
  db_name                = "mydb"
  username               = "foo"
  password               = "foobarbaz"
}

terraform {
  backend "s3" {
    bucket         = "test-bucket-43120896345235"
    key            = "terraform.tfstate"      
    region         = "eu-west-3"
    profile        = "248189943700_EKS-alumnos"
  }
}

/*

terraform {   
 backend "s3" {
    bucket         = "test-bucket-43120896345235"        
    key            = "./terraform.tfstate"      
   region         = "eu-west-3""         
   dynamodb_table = "mi-terraform-lock-table"  } }
*/