terraform {
  required_version = ">= 1.5.0"

  backend "local" {
    path = "../../state/prod/terraform.tfstate"
  }
}

locals {
  project_name = "example-project"
  environment  = "prod"
  aws_region   = "us-east-1"
  aws_profile  = "default"

  azure_subscription_id = "00000000-0000-0000-0000-000000000000"
  azure_tenant_id       = "00000000-0000-0000-0000-000000000000"

  network_cidr = "10.20.0.0/16"

  public_subnet_cidrs = [
    "10.20.0.0/24",
    "10.20.1.0/24",
    "10.20.2.0/24",
  ]

  private_subnet_cidrs = [
    "10.20.10.0/24",
    "10.20.11.0/24",
    "10.20.12.0/24",
  ]

  enable_nat_gateway = true

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

output "vpc_id" {
  description = "ID of the prod VPC"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet identifiers for prod"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet identifiers for prod"
  value       = module.network.private_subnet_ids
}
