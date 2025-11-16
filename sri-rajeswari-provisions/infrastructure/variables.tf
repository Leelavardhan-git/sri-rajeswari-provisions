variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "sri-rajeswari-provisions"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "database_username"
  description = "Postgres User"
  type        = string
  default     = "rajeswaridb"

variable "database_password"
  description  = "Postgres user pwd"
  type         = string
  default      = "password"
