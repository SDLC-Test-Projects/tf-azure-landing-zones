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
    createdBy   = var.created_by
  }
}

module "network" {
  source      = "./modules/network"
  aws_region  = var.aws_region
  cidr_block  = var.network_cidr
  environment = var.environment
  purpose     = var.network_purpose
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

output "network_id" {
  description = "Placeholder output until modules are implemented"
  value       = module.network.network_id
}
