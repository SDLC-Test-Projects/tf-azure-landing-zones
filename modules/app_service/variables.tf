variable "environment" {
  type        = string
  description = "Environment label applied to resource names and tags"
}

variable "location" {
  type        = string
  description = "Azure region where the App Service resources will live"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group containing the App Service resources"
}

variable "plan_name" {
  type        = string
  description = "Name for the App Service plan"
}

variable "plan_sku" {
  type = object({
    tier     = string
    size     = string
    capacity = optional(number)
  })
  description = "SKU configuration for the App Service plan (tier/size/capacity)"
}

variable "plan_per_site_scaling" {
  type        = bool
  description = "Enable per-site scaling on the App Service plan"
  default     = false
}

variable "plan_worker_count" {
  type        = number
  description = "Default worker count used when capacity is not specified in the SKU"
  default     = 1
}

variable "web_app_name" {
  type        = string
  description = "Name of the primary Linux Web App"
}

variable "runtime" {
  type = object({
    stack   = string
    version = string
  })
  description = "Runtime stack configuration for the Linux Web App"
}

variable "always_on" {
  type        = bool
  description = "Whether the web app should keep an instance always warm"
  default     = true
}

variable "https_only" {
  type        = bool
  description = "Force HTTPS-only traffic to the web app"
  default     = true
}

variable "client_affinity_enabled" {
  type        = bool
  description = "Enable client affinity (ARR) cookies for the app"
  default     = false
}

variable "health_check_path" {
  type        = string
  description = "Endpoint path used for platform health checks"
  default     = "/"
}

variable "app_command_line" {
  type        = string
  description = "Optional custom startup command for the web app"
  default     = ""
}

variable "app_settings" {
  type        = map(string)
  description = "Key/value application settings applied to the web app"
  default     = {}
}

variable "connection_strings" {
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  description = "Optional connection strings configured on the web app"
  default     = []
}

variable "enable_system_identity" {
  type        = bool
  description = "Toggle creation of a system-assigned managed identity on the web app"
  default     = true
}

variable "application_log_level" {
  type        = string
  description = "File system log verbosity for application logs"
  default     = "Information"
}

variable "log_retention_in_days" {
  type        = number
  description = "Number of days to retain HTTP logs on the filesystem"
  default     = 7
}

variable "log_retention_in_mb" {
  type        = number
  description = "Size limit in MB for HTTP logs stored on the filesystem"
  default     = 35
}

variable "ftps_state" {
  type        = string
  description = "FTPS access setting (Disabled, AllAllowed, or FtpsOnly)"
  default     = "Disabled"
}

variable "slots" {
  type = list(object({
    name                = string
    app_settings        = optional(map(string), {})
    always_on           = optional(bool)
    health_check_path   = optional(string)
    runtime             = optional(object({
      stack   = string
      version = string
    }))
    auto_swap_slot_name = optional(string)
    connection_strings  = optional(list(object({
      name  = string
      type  = string
      value = string
    })), [])
  }))
  description = "Optional deployment slots with their own configuration overrides"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Base tags merged onto every App Service resource"
  default     = {}
}

variable "purpose" {
  type        = string
  description = "Purpose tag value applied to App Service resources"
  default     = ""
}
