locals {
  base_name = coalesce(
    trimspace(var.name),
    "azfw"
  )

  firewall_name = join(
    "-",
    compact([
      trimspace(var.name_prefix),
      local.base_name,
      trimspace(var.name_suffix),
    ])
  )

  merged_tags = merge({
    Name        = local.firewall_name
    Environment = var.environment
  }, var.tags)
}

resource "azurerm_firewall" "this" {
  name                = local.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = var.sku.name
  sku_tier = var.sku.tier

  threat_intel_mode = var.threat_intel_mode

  dynamic "dns" {
    for_each = length(var.dns_servers) > 0 || var.dns_proxy_enabled ? [1] : []
    content {
      servers       = length(var.dns_servers) > 0 ? var.dns_servers : null
      proxy_enabled = var.dns_proxy_enabled
    }
  }

  dynamic "ip_configuration" {
    for_each = var.subnet_id != null && var.public_ip_id != null ? [var.ip_configuration_name] : []
    content {
      name                 = ip_configuration.value
      subnet_id            = var.subnet_id
      public_ip_address_id = var.public_ip_id
    }
  }

  dynamic "management_ip_configuration" {
    for_each = var.management_subnet_id != null && var.management_public_ip_id != null ? [var.management_ip_configuration_name] : []
    content {
      name                 = management_ip_configuration.value
      subnet_id            = var.management_subnet_id
      public_ip_address_id = var.management_public_ip_id
    }
  }

  dynamic "virtual_hub" {
    for_each = var.hub_vnet_id != null ? [var.hub_vnet_id] : []
    content {
      virtual_hub_id  = virtual_hub.value
      public_ip_count = var.virtual_hub_public_ip_count
    }
  }

  firewall_policy_id = var.firewall_policy_id

  tags = local.merged_tags
}

locals {
  diagnostics_categories = [
    "AzureFirewallApplicationRule",
    "AzureFirewallNetworkRule",
    "AzureFirewallDnsProxy",
  ]
}

resource "azurerm_monitor_diagnostic_setting" "log_analytics" {
  count = var.log_analytics_workspace_id != null ? 1 : 0

  name                       = "${local.firewall_name}-law"
  target_resource_id         = azurerm_firewall.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = local.diagnostics_categories
    content {
      category = enabled_log.value
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "storage" {
  count = var.storage_account_id != null ? 1 : 0

  name                       = "${local.firewall_name}-storage"
  target_resource_id         = azurerm_firewall.this.id
  storage_account_id         = var.storage_account_id

  dynamic "enabled_log" {
    for_each = local.diagnostics_categories
    content {
      category = enabled_log.value
      retention_policy {
        enabled = false
      }
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "eventhub" {
  count = var.eventhub_authorization_rule_id != null && var.eventhub_name != null ? 1 : 0

  name                           = "${local.firewall_name}-eventhub"
  target_resource_id             = azurerm_firewall.this.id
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id
  eventhub_name                  = var.eventhub_name

  dynamic "enabled_log" {
    for_each = local.diagnostics_categories
    content {
      category = enabled_log.value
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
