variable "aws_region" {
  type        = string
  description = "AWS region where the network is provisioned"
}

variable "cidr_block" {
  type        = string
  description = "Primary CIDR block for the VPC"
}

variable "environment" {
  type        = string
  description = "Environment label applied to Name and tagging"
}

variable "tags" {
  type        = map(string)
  description = "Base tags merged onto every resource"
  default     = {}
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default = [
    "10.0.0.0/24",
    "10.0.1.0/24",
  ]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
  default = [
    "10.0.10.0/24",
    "10.0.11.0/24",
  ]
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Controls whether a single NAT Gateway is created for private egress"
  default     = false
}
