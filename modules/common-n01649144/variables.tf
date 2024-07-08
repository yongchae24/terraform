
variable "humber_id" {
  type = string
  default = "n01649144"
}

variable "location" {
  type        = string
  default     = "Canada Central"
}

variable "resource_group_name" {
  type = string
  default = "n01649144-RG"
}

variable "common_tags" {
  type        = map(string)  # This way, the common_tags variable will not have default value and will be provided by th eroot module
}
