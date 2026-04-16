variable "website_name" {
  description = "User-facing website name."
  type        = string
  default     = "C3Ops Website"
}

variable "application_name" {
  description = "Application name used for tags and naming."
  type        = string
  default     = "Cloud Binary"
}

variable "core_infra_name" {
  description = "Core infrastructure name prefix used for resource naming."
  type        = string
  default     = "c3ops_preprod"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.10.0.0/16"
}

variable "azs" {
  description = "Availability zones to deploy subnets into."
  type        = list(string)
  default     = ["ap-south-2a", "ap-south-2b"]
}

variable "enable_nat_gateway" {
  description = "Whether to provision a NAT Gateway for private subnet outbound access."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Base tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "github_owner" {
  description = "GitHub organization or user owning the repository."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name containing the Terraform code."
  type        = string
}

variable "github_branch" {
  description = "GitHub branch to use for pipeline source."
  type        = string
  default     = "main"
}

variable "github_oauth_token" {
  description = "GitHub OAuth token for CodePipeline source access."
  type        = string
  sensitive   = true
}
