
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

variable "admin_username" {
  type    = string
  default = "n01649144"
}

variable "admin_password" {
  type    = string
  default = "1qaz@WSX"
}

variable "common_tags" {
  type = map(string)
}
