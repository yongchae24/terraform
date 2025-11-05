variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "Tags to apply to the security group"
  type        = map(string)
  default     = {}
}

