# C3Ops Core Infrastructure Deployment Guide

This document describes the current Terraform project structure, the AWS architecture created, and how to deploy the core infrastructure using CI/CD.

## Project Overview

The repository deploys a 3-tier AWS network architecture for the `C3Ops Website` application `Cloud Binary`.

### Core infrastructure components

- VPC
- 2 Public subnets
- 2 Private web subnets
- 2 Private app subnets
- 2 Private DB subnets
- Internet Gateway (IGW)
- NAT Gateway
- Route tables for public and private tiers
- Network ACLs for public and private subnet controls
- Security groups for web, app, and DB tiers

### AWS details

- AWS Account: `652253416761`
- Primary Region: `ap-south-2`
- Secondary Region: `ap-south-1`
- Terraform version requirement: `>= 1.9.5`

## Repository structure

- `modules/network` - contains VPC, subnet, IGW, NAT, route table, and NACL resources
- `modules/security` - contains security group resources for web/app/db tiers
- `modules/cicd` - contains CodeBuild, CodePipeline, IAM roles, and S3 artifact store
- `environments/*` - TF variable sets for environment-specific deployment
- `backend.tf` - S3 backend configuration for Terraform state
- `buildspec.yml` - CodeBuild build specification for Terraform deploy
- `README.md` - project summary and quick usage
- `DEPLOYMENT.md` - this detailed deployment guide

## Backend state management

The project uses an S3 backend defined in `backend.tf`:

- bucket: `c3ops-terraform-state1`
- key: `core-infra/terraform.tfstate`
- region: `ap-south-2`
- encrypt: `true`
- required_lock: `true`

> Note: The S3 bucket must already exist before running `terraform init`.

## Environment configuration

Each environment has a dedicated variable file under `environments/`:

- `environments/preprod/terraform.tfvars`
- `environments/prod/terraform.tfvars`
- `environments/dev/terraform.tfvars`
- `environments/test/terraform.tfvars`

These files define values such as:

- `environment`
- `region`
- `secondary_region`
- `website_name`
- `application_name`
- `core_infra_name`
- `github_owner`
- `github_repo`
- `github_branch`

The GitHub OAuth token is defined separately as a sensitive variable at runtime.

## CI/CD architecture

The CI/CD pipeline is implemented with AWS CodePipeline and AWS CodeBuild.

### Pipeline flow

1. Source stage reads code from GitHub.
2. Build stage runs CodeBuild using the repository's `buildspec.yml`.
3. CodeBuild executes Terraform commands:
   - `terraform init`
   - `terraform validate`
   - `terraform plan`
   - `terraform apply`

### CodeBuild buildspec

The current `buildspec.yml` installs Terraform 1.9.5 and runs:

- `terraform init`
- `terraform validate`
- `terraform plan -out=tfplan`
- `terraform apply -auto-approve tfplan`

This means pipeline deployments are automatic once the pipeline is created and source changes are detected.

## CI/CD variables

The pipeline requires these Terraform variables:

- `github_owner` - GitHub organization or user
- `github_repo` - repository name
- `github_branch` - branch name
- `github_oauth_token` - GitHub personal access token with repo access

The GitHub token is sensitive and should be provided securely.

## Deploying locally

### Prerequisites

- AWS credentials configured locally via environment variables, AWS profile, or IAM role
- Terraform installed locally
- `c3ops-terraform-state1` S3 bucket exists

### Deploy preprod

```bash
terraform init
terraform apply -var-file="environments/preprod/terraform.tfvars" -var="github_oauth_token=YOUR_TOKEN"
```

### Deploy prod

```bash
terraform init
terraform apply -var-file="environments/prod/terraform.tfvars" -var="github_oauth_token=YOUR_TOKEN"
```

### Deploy dev/test

```bash
terraform init
terraform apply -var-file="environments/dev/terraform.tfvars" -var="github_oauth_token=YOUR_TOKEN"
```

```bash
terraform init
terraform apply -var-file="environments/test/terraform.tfvars" -var="github_oauth_token=YOUR_TOKEN"
```

## Deploying via CI/CD

### 1. Prepare GitHub repository

- Push this repository to GitHub.
- Ensure `github_owner`, `github_repo`, and `github_branch` are set correctly in the environment tfvars.
- Create a GitHub personal access token with appropriate repository access.

### 2. Run pipeline deployment

From the root of this repo, execute:

```bash
terraform init
terraform apply -var-file="environments/preprod/terraform.tfvars" -var="github_oauth_token=YOUR_TOKEN"
```

This will create:

- AWS CodePipeline
- AWS CodeBuild project
- S3 artifact store
- IAM roles for CodeBuild and CodePipeline

### 3. Trigger pipeline

- Push a commit to the configured GitHub branch.
- CodePipeline will detect the change and start the build.
- CodeBuild runs the Terraform deployment.

## Notes and best practices

- The project currently uses GitHub OAuth token access. For production, prefer GitHub App or AWS Secrets Manager.
- The backend requires the S3 bucket to exist before `terraform init`.
- `required_lock = true` ensures Terraform state locking is enforced on S3.
- The CodeBuild IAM role currently attaches `AdministratorAccess`. In production, narrow these permissions to required Terraform actions.

## Helpful commands

Validate configuration:

```bash
terraform validate
```

Format files:

```bash
terraform fmt -recursive .
```

Plan for preprod:

```bash
terraform plan -var-file="environments/preprod/terraform.tfvars"
```

Destroy environment (use with caution):

```bash
terraform destroy -var-file="environments/preprod/terraform.tfvars" -var="github_oauth_token=YOUR_TOKEN"
```
