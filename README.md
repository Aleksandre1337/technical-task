# AWS Multi-VPC Terraform Project

Modern, flexible Terraform project for provisioning AWS VPCs with public/private subnet architecture and configurable NAT Gateway deployment modes.

## 📋 Features

- ✅ Multi-VPC deployment from single configuration
- ✅ Flexible multi-subnet architecture (public/private)
- ✅ Three NAT Gateway modes: **disabled**, **zonal**, **regional**
- ✅ Built-in validation and type safety
- ✅ Multi-AZ support
- ✅ Reusable VPC module
- ✅ Remote state management (S3)

## 🚀 NAT Gateway Modes

Configure internet access for private subnets via `nat_gateway_mode`:

| Mode | Description | HA |
|------|-------------|-----|
| **`regional`** ⭐ | AWS-managed HA across all AZs | ✅ |
| **`zonal`** | Single NAT in one AZ | ❌ |
| **`disabled`** | No internet access | N/A |

**Default:** `regional`

## 🔧 Quick Start

### Configuration

Edit `terraform.tfvars`:

```hcl
project_name = "my-project"
environment  = "dev"

vpcs = {
  primary = {
    vpc_cidr = "10.0.0.0/16"
    nat_gateway_mode = "regional"
    public_subnets = [
      { cidr_block = "10.0.1.0/24", availability_zone = "us-east-1a" },
      { cidr_block = "10.0.2.0/24", availability_zone = "us-east-1b" }
    ]
    private_subnets = [
      { cidr_block = "10.0.10.0/24", availability_zone = "us-east-1a" },
      { cidr_block = "10.0.11.0/24", availability_zone = "us-east-1b" }
    ]
  }
  
  secondary = {
    vpc_cidr = "10.1.0.0/16"
    nat_gateway_mode = "zonal"
    public_subnets = [
      { cidr_block = "10.1.1.0/24", availability_zone = "us-east-1a" }
    ]
    private_subnets = [
      { cidr_block = "10.1.10.0/24", availability_zone = "us-east-1a" }
    ]
  }
}
```

### Deploy

```bash
terraform init
terraform plan
terraform apply
```

## 📁 Project Structure

```
.
├── main.tf           # VPC module orchestration
├── variables.tf      # Input variable definitions
├── outputs.tf        # Output values
├── providers.tf      # AWS provider & S3 backend
├── terraform.tfvars  # Configuration values
└── modules/vpc/      # Reusable VPC module
    ├── main.tf       # VPC, subnets, NAT, routing
    ├── variables.tf  # Module inputs
    └── outputs.tf    # Module outputs
```

## 🏗️ Architecture

**Each VPC includes:**
- VPC with DNS enabled
- Public subnets with Internet Gateway
- Private subnets with optional NAT Gateway
- Route tables and associations
- Comprehensive tagging

## 📤 Outputs

- **`vpcs`** - Complete VPC details (IDs, subnets, gateways, route tables)
- **`vpc_ids`** - Map of VPC IDs by name

## 🔧 Prerequisites

- Terraform >= 1.0
- AWS CLI configured
- AWS Provider ~> 6.24
- S3 bucket for remote state

## ❓ Troubleshooting

**Private subnets can't reach internet:**
- Ensure `nat_gateway_mode` is `"zonal"` or `"regional"`
- Verify route table associations

**Validation error on nat_gateway_mode:**
- Only `"disabled"`, `"zonal"`, or `"regional"` are valid
- Check for typos in terraform.tfvars

**Regional NAT not available:**
- Regional NAT requires AWS Provider ~> 5.0
- Feature availability varies by region

## 📚 Resources

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Regional NAT Gateway](https://aws.amazon.com/about-aws/whats-new/2024/regional-nat-gateway/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
