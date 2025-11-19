variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "tags" {
  description = "Tags to apply to VPC"
  type        = map(string)
  default     = {}
}

