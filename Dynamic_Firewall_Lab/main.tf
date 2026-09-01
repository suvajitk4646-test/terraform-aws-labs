provider "aws" {
  region = "us-east-1"
}
locals {
  my_soc_ports = {
    ssh    = { port = 22,   description = "Admin SSH Access" }
    https  = { port = 443,  description = "Web GUI" }
    syslog = { port = 514,  description = "Log Ingestion" }
    api    = { port = 8089, description = "Tool API Access" }
  }
}

module "soc_deployment" {
  source = "./modules/soc_server"
  server_name = "primary_soc_node"
  ingress_rules = local.my_soc_ports
}