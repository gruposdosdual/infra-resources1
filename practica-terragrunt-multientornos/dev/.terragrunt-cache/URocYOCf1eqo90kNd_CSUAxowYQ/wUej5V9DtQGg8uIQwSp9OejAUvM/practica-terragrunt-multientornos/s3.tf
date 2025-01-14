resource "aws_s3_bucket" "terragrunt_bucket" {
  bucket = var.bucket_name

  tags = var.tags  
}

variable "tags" {
  description = "Etiquetas para el recurso S3"
  type        = map(string)
}
output "bucket_name" {
  value = aws_s3_bucket.terragrunt_bucket.bucket
}
