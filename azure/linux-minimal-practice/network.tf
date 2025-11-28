# Virtual Network (like AWS VPC)
resource "azurerm_virtual_network" "main" {
  name                = "${local.resource_prefix}-vnet"
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = merge(
    local.common_tags,
    {
      Name = "${local.resource_prefix}-vnet"
    }
  )
}

# Subnet (like AWS Subnet)
resource "azurerm_subnet" "main" {
  name                 = "${local.resource_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_address_prefix]
}

# Public IP (for SSH access)
resource "azurerm_public_ip" "main" {
  name                = "${var.vm_name}-public-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Basic" # Basic is cheaper than Standard

  tags = merge(
    local.common_tags,
    {
      Name = "${var.vm_name}-public-ip"
    }
  )
}

# Network Interface (connects VM to network)
resource "azurerm_network_interface" "main" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.vm_name}-nic"
    }
  )
}

# Associate NSG with Network Interface
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

