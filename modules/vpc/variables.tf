variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet configurations"
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "private_subnets" {
  description = "List of private subnet configurations"
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "nat_gateway_mode" {
  description = "NAT Gateway deployment mode: 'disabled' (no internet), 'zonal' (single NAT, cost-optimized), or 'regional' (AWS-managed HA)"
  type        = string
  default     = "regional"

  validation {
    condition     = contains(["disabled", "zonal", "regional"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be 'disabled', 'zonal', or 'regional'"
  }
}
