variable "azure_region" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus" # Cheapest region
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-linux-practice"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "vm-redhat-practice"
}

variable "vm_size" {
  description = "Size of the VM (B1s = cheapest, B2s = recommended)"
  type        = string
  default     = "Standard_B2s" # 2 vCPU, 4 GB RAM (~$30/month)
  # Alternative: "Standard_B1s" # 1 vCPU, 1 GB RAM (~$10/month) - very slow
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB"
  type        = number
  default     = 64 # Minimum required by RHEL 9 image
}

variable "data_disk_size_gb" {
  description = "Data disk size in GB (like EBS volume)"
  type        = number
  default     = 32 # Minimum billable size
}

variable "vnet_address_space" {
  description = "Address space for Virtual Network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_address_prefix" {
  description = "Address prefix for subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH (use your IP like '1.2.3.4/32' or '0.0.0.0/0' for anywhere)"
  type        = string
  default     = "0.0.0.0/0" # Change to your IP for better security!
}

