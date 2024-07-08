
output "datadisk_ids" {
  description = "The IDs of the created data disks"
  value       = azurerm_managed_disk.datadisk.*.id
}
