# Define the Kubernetes provider
provider "kubernetes" {
  config_path = "/Users/dalessi/.kube/config" 
}

provider "aws" {
  region = "eu-west-3"
}