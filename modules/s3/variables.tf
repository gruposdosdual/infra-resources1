variable "bucket_name" {
  description = "Name para el bucket"
  type        = string
}

variable "acl" {
  description = "Política de acceso al bucket"
  type = string
  default = "private"
  
}