resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  allocation_method   = var.allocation_method
  ip_address         = var.ip_address
}