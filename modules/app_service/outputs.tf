output "service_plan_id" {
  description = "Resource ID of the App Service plan"
  value       = azurerm_service_plan.this.id
}

output "service_plan_name" {
  description = "Name of the App Service plan"
  value       = azurerm_service_plan.this.name
}

output "web_app_id" {
  description = "Resource ID of the primary Linux Web App"
  value       = azurerm_linux_web_app.this.id
}

output "web_app_hostname" {
  description = "Default hostname of the primary web app"
  value       = azurerm_linux_web_app.this.default_hostname
}

output "web_app_identity_principal_id" {
  description = "Principal ID for the system-assigned identity"
  value       = try(azurerm_linux_web_app.this.identity[0].principal_id, null)
}

output "slot_hostnames" {
  description = "Mapping of slot names to their default hostnames"
  value = {
    for slot_name, slot in azurerm_linux_web_app_slot.this :
    slot_name => slot.default_hostname
  }
}

output "slot_ids" {
  description = "Mapping of slot names to their resource IDs"
  value = {
    for slot_name, slot in azurerm_linux_web_app_slot.this :
    slot_name => slot.id
  }
}
