resource "aws_s3_bucket" "terragrunt_bucket" {
  bucket = var.bucket_name  
}

/*
variable "tags" {
  description = "Etiquetas para el recurso S3"
  type        = map(string)
}
*/
output "bucket_name" {
  value = aws_s3_bucket.terragrunt_bucket.bucket
}
