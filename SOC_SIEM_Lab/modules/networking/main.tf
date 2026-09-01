resource "aws_vpc" "vpc_spoke" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "vpc_spoke"
  }
}
resource "aws_internet_gateway" "igw_spoke" {
  vpc_id = aws_vpc.vpc_spoke.id
}
resource "aws_subnet" "spoke_subnet_public" {
  vpc_id     = aws_vpc.vpc_spoke.id
  cidr_block = "10.1.1.0/24"
availability_zone = "us-east-1a"
map_public_ip_on_launch = true
  tags = {
    Name = "spoke_subnet_public"
  }
}
resource "aws_subnet" "spoke_subnet_private_a" {
  vpc_id     = aws_vpc.vpc_spoke.id
  cidr_block = "10.1.11.0/24"
availability_zone = "us-east-1a"
  tags = {
    Name = "spoke_subnet_private_a"
  }
}
resource "aws_subnet" "spoke_subnet_private_b" {
  vpc_id     = aws_vpc.vpc_spoke.id
  cidr_block = "10.1.12.0/24"
availability_zone = "us-east-1b"
  tags = {
    Name = "spoke_subnet_private_b"
  }
}
resource "aws_vpc" "vpc_hub" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "vpc_hub"
  }
}
resource "aws_internet_gateway" "igw_hub" {
  vpc_id = aws_vpc.vpc_hub.id
}
resource "aws_subnet" "hub_subnet_public" {
  vpc_id     = aws_vpc.vpc_hub.id
  cidr_block = "10.0.1.0/24"
availability_zone = "us-east-1a"
map_public_ip_on_launch = true
  tags = {
    Name = "hub_subnet_public"
  }
}
resource "aws_vpc_peering_connection" "peer" {
  peer_vpc_id = aws_vpc.vpc_hub.id
  vpc_id = aws_vpc.vpc_spoke.id
  auto_accept = true
  tags = {
    Name = "hub_spoke_peer"
  }
}
resource "aws_route_table" "rtb_spoke_public" {
  vpc_id = aws_vpc.vpc_spoke.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_spoke.id
  }
  route {
    cidr_block = "10.0.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }
}
resource "aws_route_table_association" "spoke_public_assoc" {
  subnet_id      = aws_subnet.spoke_subnet_public.id
  route_table_id = aws_route_table.rtb_spoke_public.id
}
resource "aws_route_table" "rtb_hub_public" {
  vpc_id = aws_vpc.vpc_hub.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_hub.id
  }
  route {
    cidr_block = "10.1.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }
}
resource "aws_route_table_association" "hub_public_assoc" {
  subnet_id      = aws_subnet.hub_subnet_public.id
  route_table_id = aws_route_table.rtb_hub_public.id
}
resource "aws_route_table" "rtb_spoke_private" {
  vpc_id = aws_vpc.vpc_spoke.id
  route {
    cidr_block = "10.0.0.0/16"
    vpc_peering_connection_id  = aws_vpc_peering_connection.peer.id
  }
  tags = {
    Name = "rtb_spoke_private"
  }
}
resource "aws_route_table_association" "spoke_private_a_assoc" {
  subnet_id      = aws_subnet.spoke_subnet_private_a.id
  route_table_id = aws_route_table.rtb_spoke_private.id
}
resource "aws_route_table_association" "spoke_private_b_assoc" {
  subnet_id      = aws_subnet.spoke_subnet_private_b.id
  route_table_id = aws_route_table.rtb_spoke_private.id
}