
provider "aws" {
  region = "eu-west-3"
}


provider "kubernetes" {
  config_path = "/Users/dalessi/.kube/config"  
}