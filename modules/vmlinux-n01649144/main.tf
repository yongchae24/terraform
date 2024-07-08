
resource "azurerm_availability_set" "av_set" {
  name                         = "${var.humber_id}-linux-avset"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  platform_update_domain_count = 5
  platform_fault_domain_count  = 3
}

resource "azurerm_public_ip" "public_ip" {
  for_each             = var.vm_names
  name                 = "${var.humber_id}-${each.key}-public-ip"
  location             = var.location
  resource_group_name  = var.resource_group_name
  allocation_method    = "Static"
  sku                  = "Standard"
  domain_name_label    = "${var.humber_id}-${each.value}"

  tags = var.common_tags
}

resource "azurerm_network_interface" "nic" {
  for_each                      = var.vm_names
  name                          = "${var.humber_id}-${each.key}-nic"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_accelerated_networking = false
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[each.key].id
  }

  tags = var.common_tags
}

resource "azurerm_virtual_machine" "vm" {
  for_each                       = var.vm_names
  name                           = "${var.humber_id}-${each.key}"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  availability_set_id            = azurerm_availability_set.av_set.id
  network_interface_ids          = [azurerm_network_interface.nic[each.key].id]
  vm_size                        = var.vm_size

  storage_os_disk {
    name              = "${var.humber_id}-${each.key}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_2"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.humber_id}-${each.key}"
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = file(var.public_key)
    }
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = var.storage_account_uri
  }

  tags = var.common_tags

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.admin_username
      private_key = file(var.private_key)
      host        = azurerm_public_ip.public_ip[each.key].ip_address
    }
    inline = [
      "/usr/bin/hostname"
    ]
  }
}

resource "azurerm_virtual_machine_extension" "NetworkWatcher" {
  for_each = var.vm_names
  name                 = "${var.humber_id}-${each.key}-NetworkWatcher"
  virtual_machine_id   = azurerm_virtual_machine.vm[each.key].id
  publisher            = "Microsoft.Azure.NetworkWatcher"
  type                 = "NetworkWatcherAgentLinux"
  type_handler_version = "1.0"
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "AzureMonitor" {
  for_each = var.vm_names
  name                 = "${var.humber_id}-${each.key}-AzureMonitor"
  virtual_machine_id   = azurerm_virtual_machine.vm[each.key].id
  publisher            = "Microsoft.Azure.Monitor"
  type                 = "AzureMonitorLinuxAgent"
  type_handler_version = "1.0"
  auto_upgrade_minor_version = true
}
