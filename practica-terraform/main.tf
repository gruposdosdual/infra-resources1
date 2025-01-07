module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}

module "subnet" {
  source  = "./modules/subnet"
  vpc_id  = module.vpc.vpc_id
  cidr_block = "10.0.1.0/24"
}

module "security_group" {
  source  = "./modules/security_group"
  vpc_id  = module.vpc.vpc_id
}

module "rds" {
  source                 = "./modules/rds"
  subnet_id              = module.subnet.subnet_id
  vpc_security_group_ids = [module.security_group.sg_id]
  db_name                = "mydb"
  username               = "foo"
  password               = "foobarbaz"
}
