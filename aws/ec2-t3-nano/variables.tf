
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.aws_region))
    error_message = "AWS region must be a valid region identifier."
  }
}

variable "project_name" {
  description = "Name of the project (used for resource naming and tagging)"
  type        = string
  default     = "cloudtechnote"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.project_name))
    error_message = "Project name must contain only alphanumeric characters and hyphens."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "owner" {
  description = "Owner of the resources (for tagging and cost tracking)"
  type        = string
  default     = "yongchae.ko"
}

variable "cost_center" {
  description = "Cost center for billing and budget tracking"
  type        = string
  default     = "cloudtechnote"
}

variable "instance_type" {
  description = "EC2 instance type (cost-optimized options)"
  type        = string
  default     = "t3.nano"

  validation {
    condition = contains([
      "t3.nano", "t3.micro", "t3.small", "t3.medium", "t3.large",
      "t3a.nano", "t3a.micro", "t3a.small", "t3a.medium", "t3a.large"
    ], var.instance_type)
    error_message = "Instance type must be a valid t3 or t3a instance type."
  }
}

variable "root_volume_size" {
  description = "Size of the root volume in GB (minimum 8GB)"
  type        = number
  default     = 8

  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 1000
    error_message = "Root volume size must be between 8 and 1000 GB."
  }
}

variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
