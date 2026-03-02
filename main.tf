terraform {
  backend "local" {
    path = "state/terraform.tfstate"
  }
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "network" {
  source      = "./modules/network"
  aws_region  = var.aws_region
  cidr_block  = var.network_cidr
  environment = var.environment
  tags        = local.common_tags
}

module "storage_account" {
  source              = "./modules/storage_account"
  environment         = var.environment
  location            = var.azure_location
  resource_group_name = var.azure_resource_group_name
  account_name        = var.storage_account_name
  tags                = local.common_tags
}

module "app_service" {
  source = "./modules/app_service"
  count  = var.enable_app_service ? 1 : 0

  environment         = var.environment
  location            = var.azure_location
  resource_group_name = var.azure_resource_group_name

  plan_name = var.app_service_plan_name
  plan_sku  = var.app_service_plan_sku

  web_app_name = var.app_service_name
  runtime      = var.app_service_runtime

  app_settings = var.app_service_app_settings
  slots        = var.app_service_slots

  tags = local.common_tags
}

module "firewall" {
  source = "./modules/firewall"
  count  = var.enable_firewall ? 1 : 0

  name                = var.firewall_name
  environment         = var.environment
  location            = var.azure_location
  resource_group_name = var.azure_resource_group_name

  sku               = var.firewall_sku
  threat_intel_mode = var.firewall_threat_intel_mode

  dns_servers       = var.firewall_dns_servers
  dns_proxy_enabled = var.firewall_dns_proxy_enabled

  subnet_id               = var.firewall_subnet_id
  public_ip_id            = var.firewall_public_ip_id
  management_subnet_id    = var.firewall_management_subnet_id
  management_public_ip_id = var.firewall_management_public_ip_id
  hub_vnet_id             = var.firewall_hub_vnet_id

  firewall_policy_id              = var.firewall_policy_id
  log_analytics_workspace_id      = var.firewall_log_analytics_workspace_id
  storage_account_id              = var.firewall_storage_account_id
  eventhub_authorization_rule_id  = var.firewall_eventhub_authorization_rule_id
  eventhub_name                   = var.firewall_eventhub_name

  tags = local.common_tags
}

output "network_id" {
  description = "Placeholder output until modules are implemented"
  value       = module.network.network_id
}
