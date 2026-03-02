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

output "firewall_id" {
  description = "Resource ID of the Azure Firewall"
  value       = try(module.firewall[0].id, null)
}

output "firewall_name" {
  description = "Name of the Azure Firewall"
  value       = try(module.firewall[0].name, null)
}

output "firewall_private_ip" {
  description = "Private IP address assigned to the Azure Firewall"
  value       = try(module.firewall[0].private_ip_address, null)
}

output "firewall_public_ip" {
  description = "Public IP address ID associated with the Azure Firewall"
  value       = try(module.firewall[0].public_ip_address, null)
}

output "firewall_management_public_ip" {
  description = "Management public IP address ID when forced tunneling is enabled"
  value       = try(module.firewall[0].management_public_ip_address, null)
}

output "firewall_ip_configuration" {
  description = "Primary IP configuration block for the Azure Firewall"
  value       = try(module.firewall[0].ip_configuration, null)
}
