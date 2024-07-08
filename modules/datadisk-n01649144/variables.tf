
variable "humber_id" {
  type    = string
  default = "n01649144"
}

variable "location" {
  type    = string
  default = "Canada Central"
}

variable "resource_group_name" {
  type    = string
  default = "n01649144-RG"
}

variable "disk_count" {
  type    = number
  default = 4
}

variable "linux_vm_ids" {
  type    = map(string)
}

variable "linux_vm_names" {
  type    = map(number)
  default = {
    "vm1" = 0
    "vm2" = 1
    "vm3" = 2
  }
}

variable "windows_vm_id" {
  type    = string
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
