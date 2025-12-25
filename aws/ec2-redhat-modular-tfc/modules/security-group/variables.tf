variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block for allowing ICMP traffic"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the security group"
  type        = map(string)
  default     = {}
}
