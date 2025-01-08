variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block de la subred"
  type        = string
}

variable "subnet_cidr_block_1" {
  description = "CIDR block for the first subnet"
  type        = string
}

variable "subnet_cidr_block_2" {
  description = "CIDR block for the second subnet"
  type        = string
}

