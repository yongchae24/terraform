variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for RDS subnet group"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for RDS"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
}

variable "engine_version" {
  description = "MySQL engine version"
  type        = string
}

variable "database_name" {
  description = "Initial database name"
  type        = string
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to RDS resources"
  type        = map(string)
  default     = {}
}

