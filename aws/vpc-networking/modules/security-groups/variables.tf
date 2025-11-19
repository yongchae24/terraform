variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "your_ip_cidr" {
  description = "Your IP CIDR for SSH access"
  type        = string
}

variable "tags" {
  description = "Tags to apply to security group resources"
  type        = map(string)
  default     = {}
}

