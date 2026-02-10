output "vpcs" {
  description = "Map of all VPC details"
  value = {
    for key, vpc in module.vpc : key => {
      vpc_id                 = vpc.vpc_id
      vpc_cidr_block         = vpc.vpc_cidr_block
      public_subnet_id       = vpc.public_subnet_id
      private_subnet_id      = vpc.private_subnet_id
      internet_gateway_id    = vpc.internet_gateway_id
      nat_gateway_id         = vpc.nat_gateway_id
      public_route_table_id  = vpc.public_route_table_id
      private_route_table_id = vpc.private_route_table_id
    }
  }
}

output "vpc_ids" {
  description = "List of VPC IDs"
  value       = { for key, vpc in module.vpc : key => vpc.vpc_id }
}
