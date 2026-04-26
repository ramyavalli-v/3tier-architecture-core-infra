terraform {
  backend "s3" {
    bucket  = "c3ops-terraform-state-133630512742-ap-south-1-an"
    key     = "core-infra/ap-south-1/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}
