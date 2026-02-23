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

output "app_service_plan_id" {
  description = "Resource ID of the App Service plan"
  value       = try(module.app_service[0].service_plan_id, null)
}

output "app_service_web_app_id" {
  description = "Resource ID of the App Service web app"
  value       = try(module.app_service[0].web_app_id, null)
}

output "app_service_hostname" {
  description = "Default hostname of the App Service web app"
  value       = try(module.app_service[0].web_app_hostname, null)
}

output "app_service_slot_hostnames" {
  description = "Mapping of slot names to their default hostnames"
  value       = try(module.app_service[0].slot_hostnames, {})
}
