
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr_start}.${var.account_cidr_end}"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.account}"
    VPC  = "${var.account}"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.account_cidr_start}.${10 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public_${data.aws_availability_zones.available.names[count.index]}"
    VPC  = "${var.account}"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.account_cidr_start}.${20 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "private_${data.aws_availability_zones.available.names[count.index]}"
    VPC  = "${var.account}"
  }
}

#resource "aws_route_table" "private_routing_table" {
#  count = "${length(data.aws_availability_zones.available.names)}"
#  vpc_id = aws_vpc.production.id
#
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.gw.id
#  }
#
#  tags = {
#    Name = "ig_route_table"
#    VPC  = "production"
#  }
#}
