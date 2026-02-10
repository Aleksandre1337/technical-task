variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "vpcs" {
  description = "Map of VPC configurations"
  type = map(object({
    vpc_cidr = string
    public_subnets = list(object({
      cidr_block        = string
      availability_zone = string
    }))
    private_subnets = list(object({
      cidr_block        = string
      availability_zone = string
    }))
    nat_gateway_mode = optional(string, "regional") # disabled, zonal, or regional
  }))
}
