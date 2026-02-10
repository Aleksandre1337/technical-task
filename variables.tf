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
    vpc_cidr            = string
    public_subnet_cidr  = string
    private_subnet_cidr = string
    availability_zone   = string
  }))
}
