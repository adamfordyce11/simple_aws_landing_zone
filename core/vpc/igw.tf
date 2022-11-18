resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.production.id

    tags = {
        Name = "production_igw"
        VPC  = "production"
    }
}