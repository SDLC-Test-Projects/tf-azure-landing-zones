output "vpc_id" {
  description = "ID of the provisioned VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of created public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "IDs of created private subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "internet_gateway_id" {
  description = "ID of the internet gateway when public subnets exist"
  value       = length(aws_internet_gateway.this) > 0 ? aws_internet_gateway.this[0].id : null
}

output "nat_gateway_id" {
  description = "ID of the NAT gateway when enabled"
  value       = length(aws_nat_gateway.this) > 0 ? aws_nat_gateway.this[0].id : null
}
