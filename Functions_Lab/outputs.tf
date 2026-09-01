output "deployment_time" {
  description = "The exact time this infrastructure was planned"
  value  = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
}
output "soc_team_list" {
  description = "List of SOC Team"
  value = join(", ",var.soc_team)
}
output "calculated_subnets" {
  description = "Subnets created by TF"
  value = {
    web = local.web_subnet
    app = local.app_subnet
    db = local.db_subnet
  }
}
output "raw_port" {
  description = "port number"
  value = local.raw_port
}