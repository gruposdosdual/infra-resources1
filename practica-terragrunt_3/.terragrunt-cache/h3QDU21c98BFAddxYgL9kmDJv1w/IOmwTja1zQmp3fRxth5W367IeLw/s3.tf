provider "aws" {
  region  = "eu-west-3"
  profile = "248189943700_EKS-alumnos"
}

resource "aws_s3_bucket" "terragrunt_buckt" {
  bucket = var.bucket_name   
}

output "bucket_host" {
  value = aws_s3_bucket.terragrunt_buckt.bucket
}

# Declara el backend (vacío)
terraform {
  backend "s3" {}
}