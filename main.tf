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

output "network_id" {
  description = "Placeholder output until modules are implemented"
  value       = module.network.network_id
}
