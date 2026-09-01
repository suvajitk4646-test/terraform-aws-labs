provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source             = "./modules/networking"
  spoke_vpc_cidr     = "10.0.0.0/16"
  spoke_pub_cidr     = "10.0.1.0/24"
  spoke_priv_1a_cidr = "10.0.11.0/24"
  spoke_priv_1b_cidr = "10.0.12.0/24"
  hub_vpc_cidr       = "10.1.0.0/16"
  hub_pub_cidr       = "10.1.1.0/24"
}

module "security" {
  source         = "./modules/security"
  spoke_vpc_id   = module.networking.spoke_vpc_id
  hub_vpc_id     = module.networking.hub_vpc_id
  spoke_vpc_cidr = "10.0.0.0/16"
  my_ip          = var.my_ip
}

module "database" {
  source               = "./modules/database"
  private_subnet_ids   = module.networking.spoke_private_subnet_ids
  db_security_group_id = module.security.db_sg_id
  db_password          = module.security.generated_db_password
}

module "compute" {
  source                    = "./modules/compute"
  spoke_pub_subnet_id       = module.networking.spoke_pub_subnet_id
  hub_pub_subnet_id         = module.networking.hub_pub_subnet_id
  web_sg_id                 = module.security.web_sg_id
  siem_sg_id                = module.security.siem_sg_id
  iam_instance_profile_name = module.security.web_instance_profile_name
}