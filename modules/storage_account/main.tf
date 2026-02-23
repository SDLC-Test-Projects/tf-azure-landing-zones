locals {
  name_prefix = "${var.environment}-storage"
  merged_tags = merge(
    {
      Name        = local.name_prefix
      Environment = var.environment
    },
    var.tags,
  )
}

resource "azurerm_storage_account" "this" {
  name                     = var.account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier            = var.account_tier
  account_replication_type = var.account_replication_type
  enable_https_traffic_only = true

  blob_properties {
    versioning_enabled = var.enable_blob_versioning
    delete_retention_policy {
      days = var.blob_retention_days
    }
  }

  tags = local.merged_tags
}

resource "azurerm_storage_container" "this" {
  for_each              = toset(var.containers)
  name                  = each.value
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = var.container_access_type
}
