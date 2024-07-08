
resource "azurerm_availability_set" "av_set" {
  name                         = "${var.humber_id}-win-avset"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  platform_update_domain_count = 5
  platform_fault_domain_count  = 3
}

resource "azurerm_public_ip" "public_ip" {
  count                = var.vm_count
  name                 = "${var.humber_id}-win-vm${count.index + 1}-public-ip"
  location             = var.location
  resource_group_name  = var.resource_group_name
  allocation_method    = "Static"
  sku                  = "Standard"
  domain_name_label    = "${var.humber_id}-win-vm-${count.index + 1}"

  tags = var.common_tags
}

resource "azurerm_network_interface" "nic" {
  count                        = var.vm_count
  name                         = "${var.humber_id}-win-vm${count.index + 1}-nic"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[count.index].id
  }

  tags = var.common_tags
}

resource "azurerm_virtual_machine" "vm" {
  count                        = var.vm_count
  name                         = "${var.humber_id}-win-vm${count.index + 1}"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  availability_set_id          = azurerm_availability_set.av_set.id
  network_interface_ids        = [azurerm_network_interface.nic[count.index].id]
  vm_size                      = var.vm_size

  storage_os_disk {
    name              = "${var.humber_id}-win-vm${count.index + 1}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.humber_id}-win-${count.index + 1}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = var.storage_account_uri
  }

  tags = var.common_tags
}

resource "azurerm_virtual_machine_extension" "antimalware" {
  count               = var.vm_count
  name                = "${var.humber_id}-win-vm-${count.index + 1}-antimalware"
  virtual_machine_id  = azurerm_virtual_machine.vm[count.index].id
  publisher           = "Microsoft.Azure.Security"
  type                = "IaaSAntimalware"
  type_handler_version = "1.5"
  settings            = <<SETTINGS
    {
        "AntimalwareEnabled": true
    }
SETTINGS
}
