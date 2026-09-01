data "aws_ami" "latest_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
filter {
  name = "root-device-name"
  values = ["/dev/xvda"]
}
filter {
  name = "virtualization-type"
  values = ["hvm"]
}
}

data "aws_vpc" "selected" {
default = true

}
data "aws_subnets" "available" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}
