resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.account}_igw"
    VPC  = "${var.account}"
  }
}