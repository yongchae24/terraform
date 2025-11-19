variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "private_route_table_id" {
  description = "Private route table ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to VPC endpoint"
  type        = map(string)
  default     = {}
}

