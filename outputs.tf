output "network_id" {
  description = "Identifier of the provisioned core network"
  value       = module.network.network_id
}

output "storage_account_id" {
  description = "Identifier of the provisioned storage account"
  value       = module.storage_account.storage_account_id
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint URL of the storage account"
  value       = module.storage_account.primary_blob_endpoint
}
