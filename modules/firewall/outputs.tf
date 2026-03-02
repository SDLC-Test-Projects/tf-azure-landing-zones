output "id" {
  description = "Resource ID of the Azure Firewall"
  value       = azurerm_firewall.this.id
}

output "name" {
  description = "Name of the Azure Firewall"
  value       = azurerm_firewall.this.name
}

output "ip_configuration" {
  description = "Primary IP configuration block for the firewall"
  value       = try(azurerm_firewall.this.ip_configuration[0], null)
}

output "management_ip_configuration" {
  description = "Management IP configuration block when forced tunneling is enabled"
  value       = try(azurerm_firewall.this.management_ip_configuration[0], null)
}

output "public_ip_address" {
  description = "Primary public IP address assigned to the firewall"
  value       = try(azurerm_firewall.this.ip_configuration[0].public_ip_address_id, null)
}

output "management_public_ip_address" {
  description = "Management public IP address when forced tunneling is enabled"
  value       = try(azurerm_firewall.this.management_ip_configuration[0].public_ip_address_id, null)
}

output "private_ip_address" {
  description = "Private IP address assigned to the firewall"
  value       = try(azurerm_firewall.this.ip_configuration[0].private_ip_address, null)
}

output "management_private_ip_address" {
  description = "Private IP address of the management configuration (if any)"
  value       = try(azurerm_firewall.this.management_ip_configuration[0].private_ip_address, null)
}
