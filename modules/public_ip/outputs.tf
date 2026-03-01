output "public_ip_address" {
  description = "The Public IP address"
  value       = azurerm_public_ip.example.ip_address
}

output "public_ip_id" {
  description = "The ID of the Public IP resource"
  value       = azurerm_public_ip.example.id
}