
output "vm_hostnames" {
  description = "The hostnames of the Windows VMs"
  value       = [for i in range(var.vm_count) : "${var.humber_id}-win-vm-${i + 1}"]
}

output "vm_domain_names" {
  description = "The domain names of the Windows VMs"
  value       = [for i in range(var.vm_count) : azurerm_public_ip.public_ip[i].domain_name_label]
}

output "vm_fqdn" {
  description = "The FQDN of the Windows VM"
  value       = azurerm_public_ip.public_ip[0].fqdn
}

output "vm_private_ips" {
  description = "The private IP addresses of the Windows VMs"
  value       = [for i in range(var.vm_count) : azurerm_network_interface.nic[i].private_ip_address]
}

output "vm_public_ips" {
  description = "The public IP addresses of the Windows VMs"
  value       = [for i in range(var.vm_count) : azurerm_public_ip.public_ip[i].ip_address]
}

output "vm_id" {
  description = "The ID of the Windows VM"
  value       = azurerm_virtual_machine.vm[0].id
}

output "vm_name" {
  description = "The name of the Windows VM"
  value       = azurerm_virtual_machine.vm[0].name
}
