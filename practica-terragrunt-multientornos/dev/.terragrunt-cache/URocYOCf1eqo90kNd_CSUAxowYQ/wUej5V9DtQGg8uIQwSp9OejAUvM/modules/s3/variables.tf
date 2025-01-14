variable "bucket_name" {
  description = "Nombre para el bucket"
  type        = string
}

variable "bucket_name1" {
  description = "Nombre para el bucket1"
  type        = string
}

variable "acl" {
  description = "Política de acceso al bucket"
  type = string
  default = "private"
  
}