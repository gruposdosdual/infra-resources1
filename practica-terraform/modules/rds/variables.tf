variable "subnet_id" {
  description = "ID de la subred"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "IDs de los grupos de seguridad"
  type        = list(string)
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
}

variable "username" {
  description = "Usuario administrador"
  type        = string
}

variable "password" {
  description = "Contraseña de la base de datos"
  type        = string
}
