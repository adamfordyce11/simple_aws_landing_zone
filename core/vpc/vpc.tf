
resource "aws_vpc" "vpc" {
  cidr_block           = "10.20.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "production"
    VPC  = "production"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.20.${10 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet${data.aws_availability_zones.available.names[count.index]}"
    VPC  = "production"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.20.${20 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "PrivateSubnet${data.aws_availability_zones.available.names[count.index]}"
    VPC  = "production"
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
