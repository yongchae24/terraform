
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstaten01649144RG"
    storage_account_name = "tfstaten01649144sa"
    container_name       = "tfstatefiles"
    key                  = "tfstate"
    access_key           = ""  # access key removed. Instead it is defined in an environment variable.
  }
}
