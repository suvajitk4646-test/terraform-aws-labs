locals {
  

clean_env = substr(lower(trimspace(var.environment)),0,4)
team_size=length(var.soc_team)
project_name = replace("soc security baseline", " ", "_")
is_admin_valid = contains(var.soc_team,var.admin_user)
base_tags = { ManagedBy = "Terraform"}
env_tags = { Environment = local.clean_env}
final_tags= merge(local.base_tags, local.env_tags)
web_subnet= cidrsubnet(var.vpc_cidr,8,0)
app_subnet = cidrsubnet(var.vpc_cidr,8,1)
db_subnet = cidrsubnet(var.vpc_cidr,8,2)
}
locals {
  raw_port = tonumber(var.port-number)
  raw_env = try(var.environment,"dev")
  is_valid_env = can(regex("^[a-z]+$",local.clean_env))
}

