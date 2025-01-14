## outputs.tf: Define los datos clave expuestos por el módulo.

output "bucket_host" {
  value = aws_s3_bucket.public-s3.bucket
}
