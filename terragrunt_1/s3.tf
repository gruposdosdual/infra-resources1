resource "aws_s3_bucket" "terragrunt_bucket" {
  bucket = var.bucket_name 
}

output "S3BucketName" {
  value = aws_s3_bucket.terragrunt_bucket.bucket
}

terraform {
  backend "s3" {}
}