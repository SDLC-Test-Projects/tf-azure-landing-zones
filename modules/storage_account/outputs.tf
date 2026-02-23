output "storage_account_id" {
  description = "ID of the provisioned storage account"
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint URL"
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "primary_file_endpoint" {
  description = "Primary file endpoint URL"
  value       = azurerm_storage_account.this.primary_file_endpoint
}

output "primary_connection_string" {
  description = "Primary connection string for the storage account"
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true
}
