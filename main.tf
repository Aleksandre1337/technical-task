module "vpc" {
  source   = "./modules/vpc"
  for_each = var.vpcs

  project_name    = "${var.project_name}-${each.key}"
  environment     = var.environment
  vpc_cidr        = each.value.vpc_cidr
  public_subnets  = each.value.public_subnets
  private_subnets = each.value.private_subnets
}
