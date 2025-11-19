variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "vpc1_id" {
  description = "ID of the first VPC"
  type        = string
}

variable "vpc1_cidr" {
  description = "CIDR of the first VPC"
  type        = string
}

variable "vpc1_private_route_table_id" {
  description = "Private route table ID of first VPC"
  type        = string
}

variable "vpc2_cidr" {
  description = "CIDR block for second VPC"
  type        = string
}

variable "vpc2_subnet_cidr" {
  description = "CIDR block for second VPC subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for VPC2 subnet"
  type        = string
}

variable "tags" {
  description = "Tags to apply to VPC peering resources"
  type        = map(string)
  default     = {}
}

