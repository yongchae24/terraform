
resource "azurerm_public_ip" "lb_public_ip" {
  name                = "${var.humber_id}-lb-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_address_allocation
  sku                 = "Standard"  # Ensure the SKU matches the load balancer

  tags = var.common_tags
}

resource "azurerm_lb" "load_balancer" {
  name                = "${var.humber_id}-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }

  tags = var.common_tags
}

resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  name                = "${var.humber_id}-lb-backend-pool"
  loadbalancer_id     = azurerm_lb.load_balancer.id
}

resource "azurerm_lb_nat_rule" "lb_nat_rule" {
  count               = length(var.linux_vm_nic_ids)
  name                = "${var.humber_id}-lb-nat-rule-${count.index + 1}"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.load_balancer.id
  protocol            = "Tcp"  # Correct protocol value
  frontend_port        = 6000 + count.index + 1  # Unique frontend ports starting from 6000
  backend_port        = 22
  frontend_ip_configuration_name = azurerm_lb.load_balancer.frontend_ip_configuration[0].name
}

resource "azurerm_network_interface_backend_address_pool_association" "lb_backend_association" {
  count                  = length(var.linux_vm_nic_ids)
  network_interface_id   = element(var.linux_vm_nic_ids, count.index)
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_pool.id
  ip_configuration_name  = "internal"  # Name used in azurerm_network_interface's ip_configuration block
}
