# Resource Group Outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

# Network Outputs
output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "subnet_id" {
  description = "ID of the Subnet"
  value       = azurerm_subnet.main.id
}

# VM Outputs
output "vm_id" {
  description = "ID of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.main.id
}

output "vm_name" {
  description = "Name of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.main.name
}

output "vm_private_ip" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.main.private_ip_address
}

output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.main.ip_address
}

# Disk Outputs
output "os_disk_id" {
  description = "ID of the OS disk"
  value       = azurerm_linux_virtual_machine.main.os_disk[0].name
}

output "data_disk_id" {
  description = "ID of the Data disk"
  value       = azurerm_managed_disk.data.id
}

output "data_disk_name" {
  description = "Name of the Data disk"
  value       = azurerm_managed_disk.data.name
}

# SSH Connection Command
output "ssh_command" {
  description = "Command to SSH into the VM"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.main.ip_address}"
}

# Cost Estimation
output "estimated_monthly_cost" {
  description = "Estimated monthly cost (approximate)"
  value       = "~$30-35/month (VM: $30 + Disks: $3 + Network: $1). Destroy when not using!"
}

# Data Disk Mount Instructions
output "data_disk_mount_instructions" {
  description = "Instructions to mount the data disk"
  value       = <<-EOT
    After SSH into VM, run these commands to mount the data disk:
    
    1. List disks:
       lsblk
       
    2. Partition the disk (if not partitioned):
       sudo fdisk /dev/sdc
       (n, p, 1, Enter, Enter, w)
       
    3. Create filesystem:
       sudo mkfs.ext4 /dev/sdc1
       
    4. Create mount point:
       sudo mkdir -p /mnt/data
       
    5. Mount the disk:
       sudo mount /dev/sdc1 /mnt/data
       
    6. Verify:
       df -h
       
    7. Auto-mount on boot (optional):
       echo '/dev/sdc1 /mnt/data ext4 defaults 0 0' | sudo tee -a /etc/fstab
  EOT
}

