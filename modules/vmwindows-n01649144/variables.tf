
variable "humber_id" {
  type    = string
  default = "n01649144"
}

variable "location" {
  type    = string
  default = "Canada Central"
}

variable "resource_group_name" {
  type = string
  default = "n01649144-RG"
}

variable "vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "admin_username" {
  type    = string
  default = "n01649144"
}

variable "admin_password" {
  type    = string
  default = "1qaz@WSX"
}

variable "subnet_id" {
  type = string
  # Removed default value to enforce passing it from the root module
}

variable "storage_account_uri" {
  type = string
  # Removed default value to enforce passing it from the root module
}

variable "vm_count" {
  type    = number
  default = 1
}

variable "common_tags" {
  type = map(string)
  default = {
    Assignment    = "CCGC 5502 Automation Assignment"
    Name          = "yongchae.ko"
    ExpirationDate= "2024-12-31"
    Environment   = "Learning"
  }
}
