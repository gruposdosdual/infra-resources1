provider "aws" {
  region  = "eu-west-3"
  profile = "248189943700_EKS-alumnos"
}

resource "aws_s3_bucket" "terragrunt_buckt" {
  bucket = var.bucket_name 
}


variable "bucket_name" {
  description = "Nombre para el bucket"
  type        = string
}

output "bucket_host" {
  value = aws_s3_bucket.terragrunt_buckt.bucket
}