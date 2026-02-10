module "vpc" {
  source   = "./modules/vpc"
  for_each = var.vpcs

  project_name         = "${var.project_name}-${each.key}"
  environment          = var.environment
  vpc_cidr             = each.value.vpc_cidr
  public_subnet_cidr   = each.value.public_subnet_cidr
  private_subnet_cidr  = each.value.private_subnet_cidr
  availability_zone    = each.value.availability_zone
}
