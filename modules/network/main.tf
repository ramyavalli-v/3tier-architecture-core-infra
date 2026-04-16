locals {
  public_subnet_cidrs      = [for idx in range(length(var.azs)) : cidrsubnet(var.vpc_cidr, 4, idx)]
  private_web_subnet_cidrs = [for idx in range(length(var.azs)) : cidrsubnet(var.vpc_cidr, 4, idx + 8)]
  private_app_subnet_cidrs = [for idx in range(length(var.azs)) : cidrsubnet(var.vpc_cidr, 4, idx + 16)]
  private_db_subnet_cidrs  = [for idx in range(length(var.azs)) : cidrsubnet(var.vpc_cidr, 4, idx + 24)]
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-vpc"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-igw"
  })
}

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-nat-eip"
  })
}

resource "aws_nat_gateway" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[sort(keys(aws_subnet.public))[0]].id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-nat"
  })
}

resource "aws_subnet" "public" {
  for_each = { for idx, az in sort(var.azs) : az => local.public_subnet_cidrs[idx] }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-public-${each.key}"
  })
}

resource "aws_subnet" "private_web" {
  for_each = { for idx, az in sort(var.azs) : az => local.private_web_subnet_cidrs[idx] }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-private-web-${each.key}"
  })
}

resource "aws_subnet" "private_app" {
  for_each = { for idx, az in sort(var.azs) : az => local.private_app_subnet_cidrs[idx] }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-private-app-${each.key}"
  })
}

resource "aws_subnet" "private_db" {
  for_each = { for idx, az in sort(var.azs) : az => local.private_db_subnet_cidrs[idx] }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-private-db-${each.key}"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-public-rt"
  })
}

resource "aws_route_table" "private_web" {
  count  = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-private-web-rt"
  })
}

resource "aws_route_table" "private_app" {
  count  = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-private-app-rt"
  })
}

resource "aws_route_table" "private_db" {
  count  = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-private-db-rt"
  })
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_web" {
  for_each = aws_subnet.private_web

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_web[0].id
}

resource "aws_route_table_association" "private_app" {
  for_each = aws_subnet.private_app

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_app[0].id
}

resource "aws_route_table_association" "private_db" {
  for_each = aws_subnet.private_db

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_db[0].id
}

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-public-nacl"
  })
}

resource "aws_network_acl_rule" "public_inbound_http" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  protocol       = "6"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "public_inbound_https" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  protocol       = "6"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "public_inbound_ssh" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  protocol       = "6"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "public_outbound" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-private-nacl"
  })
}

resource "aws_network_acl_rule" "private_inbound" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  egress         = false
  cidr_block     = var.vpc_cidr
}

resource "aws_network_acl_rule" "private_outbound" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.public.id
}

resource "aws_network_acl_association" "private_web" {
  for_each = aws_subnet.private_web

  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.private.id
}

resource "aws_network_acl_association" "private_app" {
  for_each = aws_subnet.private_app

  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.private.id
}

resource "aws_network_acl_association" "private_db" {
  for_each = aws_subnet.private_db

  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.private.id
}
