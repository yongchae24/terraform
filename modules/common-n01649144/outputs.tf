
output "log_analytics_workspace_name" {
  description = "The name of the log analytics workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.name
}

output "recovery_services_vault_name" {
  description = "The name of the recovery services vault"
  value       = azurerm_recovery_services_vault.recovery_vault.name
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.storage_account.name
}

output "storage_account_uri" {
  description = "The URI of the storage account for boot diagnostics"
  value       = azurerm_storage_account.storage_account.primary_blob_endpoint
}


