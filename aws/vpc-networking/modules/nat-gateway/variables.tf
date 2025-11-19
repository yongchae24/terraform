variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet for NAT Gateway"
  type        = string
}

variable "igw_id" {
  description = "ID of the Internet Gateway (for dependency)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to NAT Gateway resources"
  type        = map(string)
  default     = {}
}

