variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "tags" {
  description = "Tags to apply to Internet Gateway"
  type        = map(string)
  default     = {}
}

