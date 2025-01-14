provider "aws" {
  region  = "eu-west-3"
  profile = "248189943700_EKS-alumnos"
}

resource "aws_s3_bucket" "public-s3" {
  bucket = var.bucket_name

}

variable "bucket_name" {
  description = "Nombre para el bucket"
  type        = string
}

output "bucket_host" {
  value = aws_s3_bucket.public-s3.bucket
}