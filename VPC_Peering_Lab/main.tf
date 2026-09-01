# Primary VPC
resource "aws_vpc" "primary_VPC" {
  provider = aws.primary
  cidr_block       = var.cidr_block_primary
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = { Name = "VPC-Primary"}

  }
  #Primary Subnet
  resource "aws_subnet" "primary_subnet" {
  provider = aws.primary
  vpc_id     = aws_vpc.primary_VPC.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Primary-Subnet"
  }
}
#Primary Route-Table
resource "aws_route_table" "primary_RTB" { 
  vpc_id = aws_vpc.primary_VPC.id
  provider = aws.primary
  depends_on = [ aws_vpc.primary_VPC ]
  route  {
    cidr_block = aws_vpc.secondary_VPC.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.requester.id
  }

   tags = {Name = "RTB_VPC_Primary"}
}
#Primary Route-Table Association
resource "aws_route_table_association" "rtb_association_primary" {
  provider = aws.primary
  subnet_id = aws_subnet.primary_subnet.id
  route_table_id = aws_route_table.primary_RTB.id
}
# Primary Security-Group
resource "aws_security_group" "SG_Primary_VPC" {
  provider = aws.primary
  name = "allow_VPC_Secondary"
  description = "This SG allows traffic from Secondary VPC"
  vpc_id = aws_vpc.primary_VPC.id
  depends_on = [ aws_vpc.secondary_VPC]
  tags = {
    Name = "allow_VPC_Secondary"
}
ingress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.secondary_VPC.cidr_block]
}
egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
}
#Secondary-VPC
resource "aws_vpc" "secondary_VPC" {
  provider = aws.secondary
  cidr_block       = var.cidr_block_secondary
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = { Name = "VPC-Secondary"}
  }
  #Secondary-Subnet
  resource "aws_subnet" "secondary_subnet" {
  provider = aws.secondary
  vpc_id     = aws_vpc.secondary_VPC.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Secondary-Subnet"
  }
  }
  #Secondary Route-Table
  resource "aws_route_table" "secondary_RTB" {
  provider = aws.secondary
  vpc_id = aws_vpc.secondary_VPC.id
  depends_on = [ aws_vpc.secondary_VPC ]
  route  {
    cidr_block = aws_vpc.primary_VPC.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection_accepter.accepter.id
  }
  tags = {Name = "RTB_VPC_Secondary"}
}
#Secondary Route-Table Association
  resource "aws_route_table_association" "rtb_association_secondary" {
    provider = aws.secondary
  subnet_id = aws_subnet.secondary_subnet.id
  route_table_id = aws_route_table.secondary_RTB.id
}
#Secondary Security Group
resource "aws_security_group" "SG_Secondary_VPC" {
  provider = aws.secondary
  name = "allow_VPC_Primary"
  description = "This SG allows traffic from Primary VPC"
  vpc_id = aws_vpc.secondary_VPC.id
  depends_on = [ aws_vpc.secondary_VPC ]
  tags = {
    Name = "allow_VPC_Primary"
}
ingress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.primary_VPC.cidr_block]
}
egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
}
#Primary Server
resource "aws_instance" "instance_primary" {
  provider = aws.primary
  ami           = data.aws_ami.amazon_linux_primary.id
  instance_type = "t3.micro"
subnet_id = aws_subnet.primary_subnet.id
vpc_security_group_ids = [aws_security_group.SG_Primary_VPC.id]
  tags = {
    Name = "Primary_Server"

  }
}
#Secondary Server
resource "aws_instance" "instance_secondary" {
  provider = aws.secondary
  ami           = data.aws_ami.amazon_linux_secondary.id
  instance_type = "t3.micro"
subnet_id = aws_subnet.secondary_subnet.id
vpc_security_group_ids = [aws_security_group.SG_Secondary_VPC.id]
  tags = {
    Name = "Secondary_Server"

  }
}
#VPC-Peer-Requester
resource "aws_vpc_peering_connection" "requester" {
  provider      = aws.primary
  vpc_id        = aws_vpc.primary_VPC.id
  peer_vpc_id   = aws_vpc.secondary_VPC.id
  peer_region   = "us-west-2" # Must tell AWS where to send the request
  tags = { Name = "Cross-Region-Peering-Request" }
}
#VPC-Peer-Accepter
resource "aws_vpc_peering_connection_accepter" "accepter" {
  provider      = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.requester.id
  auto_accept = true
  tags = { Name = "Cross-Region-Peering-Accept"}
}