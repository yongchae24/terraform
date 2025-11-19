variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for ALB"
  type        = list(string)
}

variable "instance_ids" {
  description = "EC2 instance IDs to attach to target group"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to ALB resources"
  type        = map(string)
  default     = {}
}

