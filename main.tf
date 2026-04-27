module "network" {
  source             = "./modules/network"
  name_prefix        = local.name_prefix
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  azs                = var.azs
  enable_nat_gateway = var.enable_nat_gateway
  tags               = local.common_tags
}

module "security" {
  source = "./modules/security"

  name_prefix            = local.name_prefix
  environment            = var.environment
  vpc_id                 = module.network.vpc_id
  public_subnet_ids      = module.network.public_subnet_ids
  private_web_subnet_ids = module.network.private_web_subnet_ids
  private_app_subnet_ids = module.network.private_app_subnet_ids
  private_db_subnet_ids  = module.network.private_db_subnet_ids
  tags                   = local.common_tags
}