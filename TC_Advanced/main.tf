resource "aws_subnet" "example_subnets" {
  count = length(var.availability_zones)
  vpc_id = "vpc-12345678"
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = var.availability_zones[count.index]
}
resource "aws_iam_group" "groups" {  
  for_each = var.iam_group_names
  name = each.value
}
