
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.humber_id}-log-analytics"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.common_tags
}

resource "azurerm_recovery_services_vault" "recovery_vault" {
  name                = "${var.humber_id}-recovery-vault"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  tags = var.common_tags
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.humber_id}storage" # - is not allowed for naming rule
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.common_tags
}
