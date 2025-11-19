variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for subnets"
  type        = string
}

variable "tags" {
  description = "Tags to apply to subnets"
  type        = map(string)
  default     = {}
}

