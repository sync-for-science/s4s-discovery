#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "s4s" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "terraform-eks-s4s-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_subnet" "s4s" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.s4s.id

  tags = map(
    "Name", "terraform-eks-s4s-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_internet_gateway" "s4s" {
  vpc_id = aws_vpc.s4s.id

  tags = {
    Name = "terraform-eks-s4s"
  }
}

resource "aws_route_table" "s4s" {
  vpc_id = aws_vpc.s4s.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.s4s.id
  }
}

resource "aws_route_table_association" "s4s" {
  count = 2

  subnet_id      = aws_subnet.s4s.*.id[count.index]
  route_table_id = aws_route_table.s4s.id
}
