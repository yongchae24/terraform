
resource "azurerm_managed_disk" "datadisk" {
  count                = var.disk_count
  name                 = "${var.humber_id}-datadisk-${count.index + 1}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10

  tags = var.common_tags
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 30" # Introducing a 30-second delay
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "linux_disk_attachment" {
  for_each             = var.linux_vm_names
  managed_disk_id      = azurerm_managed_disk.datadisk[each.value].id
  virtual_machine_id   = var.linux_vm_ids[each.key]
  lun                  = each.value
  caching              = "ReadWrite"

  depends_on = [null_resource.delay]
}

resource "azurerm_virtual_machine_data_disk_attachment" "windows_disk_attachment" {
  managed_disk_id      = azurerm_managed_disk.datadisk[var.disk_count - 1].id
  virtual_machine_id   = var.windows_vm_id
  lun                  = var.disk_count - 1
  caching              = "ReadWrite"

  depends_on = [null_resource.delay]
}
