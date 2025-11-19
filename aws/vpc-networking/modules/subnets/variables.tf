variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to subnet resources"
  type        = map(string)
  default     = {}
}

