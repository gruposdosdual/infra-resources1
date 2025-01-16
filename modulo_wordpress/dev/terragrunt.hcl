terraform {
  source = "./"
}

inputs = {
  region        = "eu-west-3"
  vpc_cidr_block = "10.0.0.0/16"
  subnet_cidr_block = "10.0.1.0/24"
  instance_type = "t2.micro"
}
