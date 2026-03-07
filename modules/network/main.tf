locals {
  name_prefix = "${var.environment}-core"
  merged_tags = merge(
    {
      Name        = local.name_prefix
      Environment = var.environment
    },
    var.created_by != "" ? { createdBy = var.created_by } : {},
    var.tags,
  )
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.merged_tags
}

resource "aws_internet_gateway" "this" {
  count  = length(var.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = local.merged_tags
}

resource "aws_subnet" "public" {
  for_each                = length(var.public_subnet_cidrs) > 0 ? tomap({ for idx, cidr in var.public_subnet_cidrs : idx => cidr }) : {}
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = element(data.aws_availability_zones.available.names, each.key)
  map_public_ip_on_launch = true

  tags = merge(local.merged_tags, { Tier = "public" })
}

resource "aws_subnet" "private" {
  for_each          = tomap({ for idx, cidr in var.private_subnet_cidrs : idx => cidr })
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = element(data.aws_availability_zones.available.names, each.key)

  tags = merge(local.merged_tags, { Tier = "private" })
}

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  domain = "vpc"
  tags   = local.merged_tags
}

resource "aws_nat_gateway" "this" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = values(aws_subnet.public)[0].id

  tags = local.merged_tags
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_route_table" "public" {
  count  = length(var.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = length(var.public_subnet_cidrs) > 0 ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.this[0].id
    }
  }

  tags = merge(local.merged_tags, { Tier = "public" })
}

resource "aws_route_table_association" "public" {
  for_each       = length(var.public_subnet_cidrs) > 0 ? aws_subnet.public : {}
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table" "private" {
  count  = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this[0].id
    }
  }

  tags = merge(local.merged_tags, { Tier = "private" })
}

resource "aws_route_table_association" "private" {
  for_each = var.enable_nat_gateway ? aws_subnet.private : {}

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[0].id
}
