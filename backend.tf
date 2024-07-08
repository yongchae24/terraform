
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstaten01649144RG"
    storage_account_name = "tfstaten01649144sa"
    container_name       = "tfstatefiles"
    key                  = "tfstate"
  }
}
