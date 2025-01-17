terraform {
    source = "../modules"
}


inputs = {
  aws_region       = "eu-west-3"
  ami_id           = "ami-09be70e689bddcef5"
  ami_instance_type = "t2.micro"  
  rds_engine       = "mysql"
  db_instance_class = "db.t3.micro"
  environment      = "dev"
}
/*
# Referenciar el output de Terraform
dependency "db_instance" {
  config_path = "../modules"
}

output "db_endpoint" {
  value = dependency.db_instance.outputs.db_endpoint
}
*/
/*
inputs = {
  aws_region       = "eu-west-3"
  ami_id           = "ami-03e96481558ad8ee4"
  instance_type    = "t2.large"
  rds_engine       = "postgresql"
  db_instance_class = "db.t4g.micro"
  environment      = "prod"
}
*/