output "fetched_ami_id" {
    value = data.aws_ami.latest_linux.id
  
}
output "fetched_vpc_id" {
    value = data.aws_vpc.selected.id
  
}