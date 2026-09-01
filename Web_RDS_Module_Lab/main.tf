provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source                = "./modules/networking"
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidr    = "10.0.1.0/24"
  private_subnet_1_cidr = "10.0.11.0/24"
  private_subnet_2_cidr = "10.0.12.0/24"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id
}

module "database" {
  source                 = "./modules/database"
  private_subnet_ids     = module.networking.private_subnet_ids
  db_security_group_id   = module.security.db_sg_id
  db_password            = module.security.generated_db_password
}

module "compute" {
  source                    = "./modules/compute"
  public_subnet_id          = module.networking.public_subnet_id
  web_security_group_id     = module.security.web_sg_id
  iam_instance_profile_name = module.security.web_instance_profile_name
}