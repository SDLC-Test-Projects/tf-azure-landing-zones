variable "name" {
  type        = string
  description = "Base name assigned to the Azure Firewall resource"
}

variable "name_prefix" {
  type        = string
  description = "Optional prefix combined with the base firewall name"
  default     = ""
}

variable "name_suffix" {
  type        = string
  description = "Optional suffix combined with the base firewall name"
  default     = ""
}

variable "environment" {
  type        = string
  description = "Environment label merged into default tags"
}

variable "location" {
  type        = string
  description = "Azure region where the firewall is deployed"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group containing the firewall"
}

variable "sku" {
  type = object({
    name = string
    tier = string
  })
  description = "SKU configuration for the Azure Firewall (name and tier)"
  default = {
    name = "AZFW_VNet"
    tier = "Standard"
  }
}

variable "threat_intel_mode" {
  type        = string
  description = "Threat intelligence mode applied to the firewall"
  default     = "Alert"
}

variable "dns_servers" {
  type        = list(string)
  description = "Custom DNS server IP addresses applied to the firewall"
  default     = []
}

variable "dns_proxy_enabled" {
  type        = bool
  description = "Controls whether DNS proxy is enabled on the firewall"
  default     = false
}

variable "subnet_id" {
  type        = string
  description = "Resource ID of the AzureFirewallSubnet used by the firewall"
}

variable "public_ip_id" {
  type        = string
  description = "Resource ID of the public IP assigned to the firewall"
}

variable "ip_configuration_name" {
  type        = string
  description = "Name of the primary firewall IP configuration block"
  default     = "configuration"
}

variable "management_subnet_id" {
  type        = string
  description = "Resource ID of the AzureFirewallManagementSubnet when forced tunneling is enabled"
  default     = null
}

variable "management_public_ip_id" {
  type        = string
  description = "Resource ID of the management public IP when forced tunneling is enabled"
  default     = null
}

variable "management_ip_configuration_name" {
  type        = string
  description = "Name of the management IP configuration block"
  default     = "management"
}

variable "hub_vnet_id" {
  type        = string
  description = "Optional resource ID of the virtual hub hosting the firewall"
  default     = null
}

variable "virtual_hub_public_ip_count" {
  type        = number
  description = "Number of public IPs allocated when the firewall is attached to a virtual hub"
  default     = 1
}

variable "firewall_policy_id" {
  type        = string
  description = "Optional resource ID of an Azure Firewall Policy associated with the firewall"
  default     = null
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource ID of the Log Analytics workspace for firewall diagnostics"
  default     = null
}

variable "storage_account_id" {
  type        = string
  description = "Resource ID of the storage account receiving firewall diagnostics"
  default     = null
}

variable "eventhub_authorization_rule_id" {
  type        = string
  description = "Authorization rule ID for the Event Hub target used by diagnostics"
  default     = null
}

variable "eventhub_name" {
  type        = string
  description = "Name of the Event Hub receiving firewall diagnostics"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Base tags merged onto every firewall resource"
  default     = {}
}
