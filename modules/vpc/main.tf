# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  for_each = { for idx, subnet in var.public_subnets : idx => subnet }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${each.key}"
    Type = "Public"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each = { for idx, subnet in var.private_subnets : idx => subnet }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = "${var.project_name}-private-subnet-${each.key}"
    Type = "Private"
  }
}

# Elastic IP for zonal NAT Gateway mode
resource "aws_eip" "nat" {
  count = var.nat_gateway_mode == "zonal" ? 1 : 0

  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }

  depends_on = [aws_internet_gateway.main]
}

# NAT Gateway - Zonal Mode (single NAT, cost-optimized)
resource "aws_nat_gateway" "zonal" {
  count = var.nat_gateway_mode == "zonal" ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.project_name}-nat-gateway-zonal"
  }

  depends_on = [aws_internet_gateway.main]
}

# NAT Gateway - Regional Mode (AWS-managed HA)
resource "aws_nat_gateway" "regional" {
  count = var.nat_gateway_mode == "regional" ? 1 : 0

  vpc_id            = aws_vpc.main.id
  connectivity_type = "public"
  availability_mode = "regional"

  tags = {
    Name = "${var.project_name}-nat-gateway-regional"
  }

  depends_on = [aws_internet_gateway.main]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-public-rt"
    Type = "Public"
  }
}

# Public Route to Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Public Subnet Route Table Associations
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-private-rt"
    Type = "Private"
  }
}

# Private Route to NAT Gateway - Zonal Mode
resource "aws_route" "private_nat_zonal" {
  count = var.nat_gateway_mode == "zonal" ? 1 : 0

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.zonal[0].id
}

# Private Route to NAT Gateway - Regional Mode
resource "aws_route" "private_nat_regional" {
  count = var.nat_gateway_mode == "regional" ? 1 : 0

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.regional[0].id
}

# Private Subnet Route Table Associations
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
