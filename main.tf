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
  source       = "./modules/network"
  aws_region   = var.aws_region
  cidr_block   = var.network_cidr
  environment  = var.environment
  tags         = local.common_tags
}

output "network_id" {
  description = "Placeholder output until modules are implemented"
  value       = module.network.network_id
}
