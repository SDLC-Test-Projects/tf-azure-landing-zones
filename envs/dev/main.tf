terraform {
  required_version = ">= 1.5.0"

  backend "local" {
    path = "../../state/dev/terraform.tfstate"
  }
}

locals {
  project_name = "example-project"
  environment  = "dev"
  aws_region   = "us-east-1"
  aws_profile  = "default"

  azure_subscription_id = "00000000-0000-0000-0000-000000000000"
  azure_tenant_id       = "00000000-0000-0000-0000-000000000000"

  network_cidr = "10.10.0.0/16"

  public_subnet_cidrs = [
    "10.10.0.0/24",
    "10.10.1.0/24",
  ]

  private_subnet_cidrs = [
    "10.10.10.0/24",
    "10.10.11.0/24",
  ]

  enable_nat_gateway = false

  azure_location            = "eastus"
  azure_resource_group_name = "dev-rg"
  storage_account_name      = "devstore001"

  enable_app_service = false

  app_service_plan = {
    name = "dev-asp"
    sku = {
      tier = "PremiumV2"
      size = "P1v2"
    }
  }

  app_service = {
    name     = "dev-webapp"
    runtime  = { stack = "NODE", version = "18-lts" }
    settings = {
      "WEBSITE_RUN_FROM_PACKAGE" = "1"
    }
    slots = []
  }

  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    ManagedBy   = "terraform"
  }
}

provider "aws" {
  region  = local.aws_region
  profile = local.aws_profile
}

provider "azurerm" {
  features {}
  subscription_id = local.azure_subscription_id
  tenant_id       = local.azure_tenant_id
}

module "network" {
  source = "../../modules/network"

  aws_region  = local.aws_region
  cidr_block  = local.network_cidr
  environment = local.environment
  tags        = local.common_tags

  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
  enable_nat_gateway   = local.enable_nat_gateway
}

module "storage_account" {
  source = "../../modules/storage_account"

  environment              = local.environment
  location                 = local.azure_location
  resource_group_name      = local.azure_resource_group_name
  account_name             = local.storage_account_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.common_tags

  containers = ["dev-container"]
}

module "app_service" {
  source = "../../modules/app_service"
  count  = local.enable_app_service ? 1 : 0

  environment         = local.environment
  location            = local.azure_location
  resource_group_name = local.azure_resource_group_name

  plan_name             = local.app_service_plan.name
  plan_sku              = local.app_service_plan.sku
  plan_per_site_scaling = false

  web_app_name = local.app_service.name
  runtime      = local.app_service.runtime

  app_settings = local.app_service.settings
  slots        = local.app_service.slots

  tags = local.common_tags
}

output "vpc_id" {
  description = "ID of the dev VPC"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet identifiers for dev"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet identifiers for dev"
  value       = module.network.private_subnet_ids
}

output "storage_account_id" {
  description = "ID of the dev storage account"
  value       = module.storage_account.storage_account_id
}

output "storage_account_name" {
  description = "Name of the dev storage account"
  value       = module.storage_account.storage_account_name
}

output "storage_account_blob_endpoint" {
  description = "Primary blob endpoint for dev storage account"
  value       = module.storage_account.primary_blob_endpoint
}

output "app_service_hostname" {
  description = "Default hostname for the dev App Service"
  value       = local.enable_app_service ? module.app_service[0].web_app_hostname : null
}
