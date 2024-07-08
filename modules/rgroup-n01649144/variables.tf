
variable "humber_id" {
  type = string
  default = "n01649144"
}

variable "location" {
  type        = string
  default     = "Canada Central"
}

variable "common_tags" {
  type        = map(string)
  default     = {
    Assignment    = "CCGC 5502 Automation Assignment"
    Name          = "yongchae.ko"
    ExpirationDate= "2024-12-31"
    Environment   = "Learning"
  }
}
