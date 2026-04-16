variable "region" {
  description = "Primary AWS region for core infrastructure deployments."
  type        = string
  default     = "ap-south-2"
}

variable "secondary_region" {
  description = "Secondary AWS region for DR or future cross-region resources."
  type        = string
  default     = "ap-south-1"
}

provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}
