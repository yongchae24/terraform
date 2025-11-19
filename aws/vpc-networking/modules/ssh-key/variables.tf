variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "tags" {
  description = "Tags to apply to SSH key"
  type        = map(string)
  default     = {}
}

