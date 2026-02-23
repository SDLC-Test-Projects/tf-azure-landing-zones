variable "project_name" {
  type        = string
  description = "Human-friendly name for tagging resources"
  default     = "example-project"
}

variable "environment" {
  type        = string
  description = "Deployment environment identifier"
  default     = "dev"
}

variable "aws_region" {
  type        = string
  description = "AWS region used by root modules"
  default     = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "Named AWS CLI profile leveraged by the provider"
  default     = "default"
}

variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription identifier"
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure tenant identifier"
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "enable_azure_network" {
  type        = bool
  description = "Toggle to provision the Azure virtual network module"
  default     = false
}

variable "azure_vnet_address_space" {
  type        = list(string)
  description = "CIDR blocks assigned to the Azure virtual network"
  default     = ["10.20.0.0/16"]
}

variable "azure_subnet_prefixes" {
  type        = map(string)
  description = "Map of subnet keys to CIDR prefixes within the Azure VNet"
  default = {
    default = "10.20.1.0/24"
  }
}

variable "azure_subnet_name_map" {
  type        = map(string)
  description = "Optional mapping of subnet keys to explicit Azure subnet names"
  default     = {}
}

variable "network_cidr" {
  description = "Base CIDR block for the core network"
  default     = "10.0.0.0/16"
}

variable "azure_location" {
  type        = string
  description = "Azure region for resources"
  default     = "eastus"
}

variable "azure_resource_group_name" {
  type        = string
  description = "Name of the Azure resource group"
  default     = "example-rg"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account"
  default     = "examplestorage"
}

variable "enable_app_service" {
  type        = bool
  description = "Toggle to provision the Azure App Service module"
  default     = false
}

variable "app_service_plan_name" {
  type        = string
  description = "Name assigned to the App Service plan"
  default     = "example-asp"
}

variable "app_service_plan_sku" {
  type = object({
    tier = string
    size = string
  })
  description = "SKU tier and size for the App Service plan"
  default = {
    tier = "PremiumV2"
    size = "P1v2"
  }
}

variable "app_service_name" {
  type        = string
  description = "Name of the primary App Service web app"
  default     = "example-webapp"
}

variable "app_service_runtime" {
  type = object({
    stack   = string
    version = string
  })
  description = "Runtime stack configuration for the Linux App Service"
  default = {
    stack   = "NODE"
    version = "18-lts"
  }
}

variable "app_service_app_settings" {
  type        = map(string)
  description = "App settings passed to the App Service instance"
  default     = {}
}

variable "app_service_slots" {
  type = list(object({
    name         = string
    app_settings = map(string)
  }))
  description = "Optional deployment slots with their own app settings"
  default     = []
}
