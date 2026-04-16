terraform {
  backend "s3" {
    bucket  = "c3ops-terraform-state1"
    key     = "core-infra/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}
