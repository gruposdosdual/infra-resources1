variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ec2_key_name" {
  description = "EC2 SSH key name"
  type        = string
}

variable "db_identifier" {
  description = "RDS DB identifier name"
  type        = string
  default     = "my-database-instance-dad"
}

variable "db_engine" {
  description = "RDS DB engine name"
  type = string
  default = "mysql"
}

variable "db_engine_version" {
  description = "RDS DB engine version"
  type = string
  default = "8.0"
}

variable "db_instance_class" {
  description = "RDS DB instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_storage" {
  description = "Allocated storage for RDS instance"
  type        = number
  default     = 5
}

variable "db_storage_type" {
  description = "RDS DB storage type"
  type        = string
  default     = "gp2"
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "mydatabase"
}

variable "db_user" {
  description = "RDS database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}