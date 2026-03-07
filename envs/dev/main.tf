module "public_ip" {
  source = "../../modules/public_ip"

  allocation_method   = "Static" # or Dynamic based on requirement
  location            = local.azure_location
  resource_group_name = local.azure_resource_group_name
  tags                = local.common_tags
}