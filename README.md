# C3Ops Website Core Infrastructure

Terraform modules and environment configuration for a 3-tier AWS architecture supporting:

- Website: `C3Ops Website`
- Application: `Cloud Binary`
- Environments: `preprod`, `prod`
- Deployment region: `ap-south-2`
- Secondary region available as `ap-south-1`
- Core network components: VPC, public/private subnets, IGW, NAT Gateway, route tables, NACLs, security groups

## Structure

- `modules/network` - VPC and subnet topology, internet gateway, NAT gateway, route tables, network ACLs
- `modules/security` - security groups for web, app, db tiers
- `environments/preprod` - environment-specific variables for preprod
- `environments/prod` - environment-specific variables for prod

## Usage

1. Initialize Terraform:

```bash
terraform init
```

2. Validate configuration:

```bash
terraform validate
```

3. Apply for preprod:

```bash
terraform apply -var-file="environments/preprod/terraform.tfvars"
```

4. Apply for prod:

```bash
terraform apply -var-file="environments/prod/terraform.tfvars"
```

## Notes

- The project is designed for Terraform `>= 1.9.5`.
- AWS Account: `652253416761`
- Region: `ap-south-2`
- Core infra prefix: `c3ops_preprod`
- AWS CodeBuild support is included via `buildspec.yml`.
- AWS CodePipeline source uses GitHub and requires `github_owner`, `github_repo`, and `github_oauth_token`.

## Detailed Deployment Guide

See `DEPLOYMENT.md` for full architecture details and step-by-step CI/CD deployment instructions.
