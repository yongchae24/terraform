variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "instance_type" {
  description = "Instance type for bastion"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID for bastion"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for bastion"
  type        = string
}

variable "tags" {
  description = "Tags to apply to bastion"
  type        = map(string)
  default     = {}
}

