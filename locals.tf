locals {
  name_prefix = lower(replace(var.core_infra_name, " ", "-"))

  common_tags = merge(
    {
      Name        = "${local.name_prefix}-${var.environment}"
      Project     = var.website_name
      Application = var.application_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}
