# Resource Group
# Container for all Azure resources
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.azure_region

  tags = merge(
    local.common_tags,
    {
      Name = var.resource_group_name
    }
  )
}

