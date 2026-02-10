output "vpcs" {
  description = "Map of all VPC details"
  value = {
    for key, vpc in module.vpc : key => {
      vpc_id                     = vpc.vpc_id
      vpc_cidr_block             = vpc.vpc_cidr_block
      public_subnet_ids          = vpc.public_subnet_ids
      private_subnet_ids         = vpc.private_subnet_ids
      public_subnet_cidr_blocks  = vpc.public_subnet_cidr_blocks
      private_subnet_cidr_blocks = vpc.private_subnet_cidr_blocks
      internet_gateway_id        = vpc.internet_gateway_id
      nat_gateway_ids            = vpc.nat_gateway_ids
      nat_gateway_mode           = vpc.nat_gateway_mode
      public_route_table_id      = vpc.public_route_table_id
      private_route_table_ids    = vpc.private_route_table_ids
    }
  }
}

output "vpc_ids" {
  description = "List of VPC IDs"
  value       = { for key, vpc in module.vpc : key => vpc.vpc_id }
}
