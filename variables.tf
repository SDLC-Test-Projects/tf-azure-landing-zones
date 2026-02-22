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

variable "network_cidr" {
  type        = string
  description = "Base CIDR block for the core network"
  default     = "10.0.0.0/16"
}
