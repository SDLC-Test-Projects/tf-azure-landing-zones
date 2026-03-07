locals {
  merged_tags = merge(
    {
      Name        = var.web_app_name
      Environment = var.environment
    },
    var.tags,
  )

  slot_map = { for slot in var.slots : slot.name => slot }

  primary_linux_fx_version = format("%s|%s", upper(var.runtime.stack), var.runtime.version)

  slot_linux_fx_versions = {
    for slot in var.slots :
    slot.name => slot.runtime != null ? format("%s|%s", upper(slot.runtime.stack), slot.runtime.version) : local.primary_linux_fx_version
  }
}

resource "azurerm_service_plan" "this" {
  name                     = var.plan_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  os_type                  = "Linux"
  sku_name                 = var.plan_sku.size
  per_site_scaling_enabled = var.plan_per_site_scaling
  worker_count             = coalesce(try(var.plan_sku.capacity, null), var.plan_worker_count)

  tags = local.merged_tags
}

resource "azurerm_linux_web_app" "this" {
  name                = var.web_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id

  https_only              = var.https_only
  client_affinity_enabled = var.client_affinity_enabled
  app_settings            = var.app_settings

  site_config {
    always_on           = var.always_on
    linux_fx_version    = local.primary_linux_fx_version
    ftps_state          = var.ftps_state
    health_check_path   = var.health_check_path
    app_command_line    = var.app_command_line != "" ? var.app_command_line : null
    minimum_tls_version = "1.2"
  }

  dynamic "connection_string" {
    for_each = { for cs in var.connection_strings : cs.name => cs }
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = var.log_retention_in_days
        retention_in_mb   = var.log_retention_in_mb
      }
    }

    application_logs {
      file_system_level = var.application_log_level
    }
  }

  identity {
    type = var.enable_system_identity ? "SystemAssigned" : "None"
  }

  tags = local.merged_tags
}

resource "azurerm_linux_web_app_slot" "this" {
  for_each = local.slot_map

  name            = each.value.name
  app_service_id  = azurerm_linux_web_app.this.id
  service_plan_id = azurerm_service_plan.this.id

  https_only              = var.https_only
  client_affinity_enabled = var.client_affinity_enabled
  auto_swap_slot_name     = try(each.value.auto_swap_slot_name, null)

  app_settings = merge(var.app_settings, try(each.value.app_settings, {}))

  site_config {
    always_on           = try(each.value.always_on, var.always_on)
    linux_fx_version    = local.slot_linux_fx_versions[each.key]
    ftps_state          = var.ftps_state
    health_check_path   = try(each.value.health_check_path, var.health_check_path)
    app_command_line    = var.app_command_line != "" ? var.app_command_line : null
    minimum_tls_version = "1.2"
  }

  dynamic "connection_string" {
    for_each = { for cs in try(each.value.connection_strings, []) : cs.name => cs }
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = var.log_retention_in_days
        retention_in_mb   = var.log_retention_in_mb
      }
    }

    application_logs {
      file_system_level = var.application_log_level
    }
  }

  dynamic "identity" {
    for_each = var.enable_system_identity ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  tags = local.merged_tags
}
