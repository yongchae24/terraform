# Managed Data Disk (like AWS EBS Volume)
resource "azurerm_managed_disk" "data" {
  name                 = "${var.vm_name}-data-disk"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  storage_account_type = "Standard_LRS" # Standard HDD (cheapest)
  create_option        = "Empty"
  disk_size_gb         = var.data_disk_size_gb

  tags = merge(
    local.common_tags,
    {
      Name = "${var.vm_name}-data-disk"
      Type = "Data"
    }
  )
}

# Attach Data Disk to VM
resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  managed_disk_id    = azurerm_managed_disk.data.id
  virtual_machine_id = azurerm_linux_virtual_machine.main.id
  lun                = 0
  caching            = "ReadWrite"
}

