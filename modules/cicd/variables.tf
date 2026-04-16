variable "name_prefix" {
  description = "Name prefix for CI/CD resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
}

variable "github_owner" {
  description = "GitHub organization or user that owns the repo."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name containing Terraform code."
  type        = string
}

variable "github_branch" {
  description = "GitHub branch to use as the source for the pipeline."
  type        = string
  default     = "main"
}

variable "github_oauth_token" {
  description = "GitHub OAuth token used by CodePipeline to access the repository."
  type        = string
  sensitive   = true
}

variable "buildspec_path" {
  description = "Path to the CodeBuild buildspec file."
  type        = string
  default     = "buildspec.yml"
}

variable "tags" {
  description = "Tags applied to CI/CD resources."
  type        = map(string)
  default     = {}
}
