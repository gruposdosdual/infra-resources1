variable "bucket_name" {
  description = "Nombre para el bucket"
  type        = string
}

variable "acl" {
  description = "Política de acceso al bucket"
  type = string
  default = "private"
  
}