
resource "azurerm_postgresql_server" "postgresql_server" {
  name                = "${var.humber_id}-postgresql-server"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "B_Gen5_1"
  storage_mb          = 5120
  backup_retention_days = 7
  administrator_login = var.admin_username
  administrator_login_password = var.admin_password
  version             = "11"
  ssl_enforcement_enabled = true
  
  tags = var.common_tags
}

resource "azurerm_postgresql_database" "postgresql_database" {
  name                = "${var.humber_id}-postgresql-db"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
  
  depends_on = [azurerm_postgresql_server.postgresql_server]
}
