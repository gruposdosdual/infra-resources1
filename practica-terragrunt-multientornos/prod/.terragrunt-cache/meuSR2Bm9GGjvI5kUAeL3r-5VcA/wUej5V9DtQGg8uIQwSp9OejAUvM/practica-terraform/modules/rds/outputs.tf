output "endpoint" {
  description = "El endpoint de la instancia principal de RDS"
  value       = aws_db_instance.default.endpoint
}
