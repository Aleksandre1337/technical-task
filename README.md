# AWS Multi-VPC Terraform Project

Terraform project for provisioning multiple AWS VPCs with public/private subnet architecture, NAT gateways, and internet gateways.

## 📋 Infrastructure Components

Each VPC includes:
- VPC with custom CIDR block
- Public subnet with Internet Gateway
- Private subnet with NAT Gateway
- Route tables and associations
- Elastic IP for NAT Gateway
- DNS support enabled

## 🔧 Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- S3 bucket for remote state (`alex-terrastate`)
- AWS Provider ~> 5.0

## ⚙️ Configuration

Edit `terraform.tfvars` to customize your VPCs:

```hcl
project_name = "your-project"
environment  = "dev"

vpcs = {
  primary = {
    vpc_cidr             = "10.0.0.0/16"
    public_subnet_cidr   = "10.0.1.0/24"
    private_subnet_cidr  = "10.0.2.0/24"
    availability_zone    = "us-east-1a"
  }
  secondary = {
    vpc_cidr             = "10.1.0.0/16"
    public_subnet_cidr   = "10.1.1.0/24"
    private_subnet_cidr  = "10.1.2.0/24"
    availability_zone    = "us-east-1b"
  }
}
```

## 📤 Outputs

- `vpcs` - Complete details for all VPCs (IDs, CIDR blocks, subnet IDs, gateway IDs, route table IDs)
- `vpc_ids` - Map of VPC IDs by name

## 📁 Project Structure

```
.
├── .gitignore        # Git ignore patterns
├── .terraform.lock.hcl  # Terraform dependency lock file
├── locals.tf         # Local values and variables
├── main.tf           # Root module configuration
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── providers.tf      # Provider and backend configuration
├── terraform.tfvars  # Variable values
├── README.md         # This file
└── modules/
    └── vpc/          # Reusable VPC module
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

## 🔐 Backend Configuration

State is stored remotely in S3:
- Bucket: `alex-terrastate`
- Region: `us-east-1`
- Key: `terraform.tfstate`

## 📝 Notes

- Public subnets have auto-assign public IP enabled
- Private subnets route through NAT Gateway for outbound internet access
- Each VPC is isolated and can be configured independently
- Resources are tagged with project name and environment
