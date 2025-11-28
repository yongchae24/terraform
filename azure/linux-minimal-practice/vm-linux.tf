# Linux Virtual Machine (Red Hat Enterprise Linux)
resource "azurerm_linux_virtual_machine" "main" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vm_size
  admin_username      = var.admin_username

  # Network interface
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  # SSH Key authentication (no password)
  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  # OS Disk configuration
  os_disk {
    name                 = "${var.vm_name}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS" # Standard HDD (cheapest)
    disk_size_gb         = var.os_disk_size_gb
  }

  # Red Hat Enterprise Linux 9
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "9-lvm-gen2"
    version   = "latest"
  }

  # Disable boot diagnostics to save cost
  boot_diagnostics {
    storage_account_uri = null
  }

  tags = merge(
    local.common_tags,
    {
      Name = var.vm_name
      OS   = "Red Hat Enterprise Linux 9"
    }
  )
}

