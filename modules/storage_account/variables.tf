variable "environment" {
  type        = string
  description = "Environment label applied to Name and tagging"
}

variable "location" {
  type        = string
  description = "Azure region where the storage account is provisioned"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "account_name" {
  type        = string
  description = "Name of the storage account"
}

variable "account_tier" {
  type        = string
  description = "Storage account tier (Standard or Premium)"
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Replication type (LRS, GRS, ZRS, GZRS, RA-GRS, RA-GZRS)"
  default     = "LRS"
}

variable "enable_blob_versioning" {
  type        = bool
  description = "Enable blob versioning"
  default     = true
}

variable "blob_retention_days" {
  type        = number
  description = "Number of days to retain deleted blobs"
  default     = 7
}

variable "containers" {
  type        = list(string)
  description = "List of container names to create"
  default     = []
}

variable "container_access_type" {
  type        = string
  description = "Container access type (private, blob, container)"
  default     = "private"
}

variable "tags" {
  type        = map(string)
  description = "Base tags merged onto every resource"
  default     = {}
}
