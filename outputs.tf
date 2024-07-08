
output "_01_resource_group_name" {
  description = "The name of the resource group created by the child module"
  value       = module.rgroup-n01649144.resource_group_name
}

output "_02_virtual_network_name" {
  description = "The name of the virtual network created by the child module"
  value       = module.network-n01649144.virtual_network_name
}

output "_03_subnet_name" {
  description = "The name of the subnet created by the child module"
  value       = module.network-n01649144.subnet_name
}
##################################

output "_04_log_analytics_workspace_name" {
  description = "The name of the log analytics workspace created by the child module"
  value       = module.common-n01649144.log_analytics_workspace_name
}

output "_05_recovery_services_vault_name" {
  description = "The name of the recovery services vault created by the child module"
  value       = module.common-n01649144.recovery_services_vault_name
}

output "_06_storage_account_name" {
  description = "The name of the storage account created by the child module"
  value       = module.common-n01649144.storage_account_name
}
###################################

output "_07_linux_vm_hostnames" {
  description = "The hostnames of the VMs created by the vmlinux module"
  value       = module.vmlinux-n01649144.vm_hostnames
}

output "_08_linux_vm_domain_names" {
  description = "The domain names of the VMs created by the vmlinux module"
  value       = module.vmlinux-n01649144.vm_domain_names
}

output "_09_linux_vm_fqdns" {
  description = "The FQDNs of the Linux VMs"
  value       = module.vmlinux-n01649144.vm_fqdns
}

output "_10_linux_vm_private_ips" {
  description = "The private IP addresses of the VMs created by the vmlinux module"
  value       = module.vmlinux-n01649144.vm_private_ips
}

output "_11_linux_vm_public_ips" {
  description = "The public IP addresses of the VMs created by the vmlinux module"
  value       = module.vmlinux-n01649144.vm_public_ips
}
####################################

output "_12_windows_vm_hostnames" {
  description = "The hostnames of the Windows VMs created by the vmwindows module"
  value       = module.vmwindows-n01649144.vm_hostnames
}

output "_13_windows_vm_domain_names" {
  description = "The domain names of the Windows VMs created by the vmwindows module"
  value       = module.vmwindows-n01649144.vm_domain_names
}

output "_14_windows_vm_fqdn" {
  description = "The FQDN of the Windows VM"
  value       = module.vmwindows-n01649144.vm_fqdn
}

output "_15_windows_vm_private_ips" {
  description = "The private IP addresses of the Windows VMs created by the vmwindows module"
  value       = module.vmwindows-n01649144.vm_private_ips
}

output "_16_windows_vm_public_ips" {
  description = "The public IP addresses of the Windows VMs created by the vmwindows module"
  value       = module.vmwindows-n01649144.vm_public_ips
}
###################################

output "_17_load_balancer_name" {
  description = "The name of the Load Balancer created by the loadbalancer module"
  value       = module.loadbalancer-n01649144.load_balancer_name
}

output "_18_db_server_name" {
  description = "The name of the PostgreSQL server created by the database module"
  value       = module.database-n01649144.db_server_name
}

output "_19_db_name" {
  description = "The name of the PostgreSQL database created by the database module"
  value       = module.database-n01649144.db_name
}



