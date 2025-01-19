terraform {
    source = "../modules"
}

/*
locals {
    aws_region = fileexists("region_1.tfvars") ? jsondecode(file("region_1.tfvars")).aws_region : "eu-west-3"
}
*/
inputs = {
  aws_region       = local.aws_region #var.aws_region  # Utiliza una variable para la región, en este caso el uso incorrecto de var.aws_region
  ami_id           = "ami-09be70e689bddcef5"
  ami_instance_type = "t2.micro"  
  rds_engine       = "mysql"
  db_instance_class = "db.t3.micro"
  environment      = "dev"
}

locals {
  aws_region = read_terragrunt_config(find_in_parent_folders("region.tfvars")).inputs.aws_region
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