output "vpc_id" {
  description = "The VPC ID for the core network."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.network.public[*].id
}

output "private_web_subnet_ids" {
  description = "Private web tier subnet IDs."
  value       = module.network.private_web[*].id
}

output "private_app_subnet_ids" {
  description = "Private app tier subnet IDs."
  value       = module.network.private_app[*].id
}

output "private_db_subnet_ids" {
  description = "Private database subnet IDs."
  value       = module.network.private_db[*].id
}

output "security_group_ids" {
  description = "Security groups created for the application tiers."
  value       = module.security.security_group_ids
}
