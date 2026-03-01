## Azure Public IP Module

This module provisions an Azure Public IP address. It can be configured for either static or dynamic allocation.

### Usage

To use the Azure Public IP module, include the following in your environment's `main.tf`:

```hcl
module "public_ip" {
  source  = "../../modules/public_ip"  # Adjust the path as necessary
  allocation_method = "Static"          # Options: "Static" or "Dynamic"
  location          = var.azure_location  # Required: Region where the IP will be created
  resource_group_name = var.azure_resource_group_name  # Required: Resource group to hold the IP
  tags              = var.common_tags
}
```

### Variables

The following variables are used for configuring the module:

- `ip_address` (optional): A static IP address to assign.
- `allocation_method` (required): Method of allocation ("Static" or "Dynamic").
- `sku` (optional): SKU type ("Basic" or "Standard").

### Outputs

Upon creation, this module will output:

- `public_ip_address`: The allocated public IP address.
- `public_ip_id`: The ID of the allocated public IP resource.
