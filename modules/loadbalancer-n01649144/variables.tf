
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

variable "linux_vm_nic_ids" {
  type = list(string)
}

variable "public_ip_address_allocation" {
  type    = string
  default = "Static"
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
