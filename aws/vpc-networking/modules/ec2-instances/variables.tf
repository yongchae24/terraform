variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EC2 instances (first 2 only)"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for EC2 instances"
  type        = string
}

variable "tags" {
  description = "Tags to apply to EC2 instances"
  type        = map(string)
  default     = {}
}

