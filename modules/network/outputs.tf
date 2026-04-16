output "vpc_id" {
  description = "VPC identifier."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets."
  value       = values(aws_subnet.public)[*].id
}

output "private_web_subnet_ids" {
  description = "IDs of private web subnets."
  value       = values(aws_subnet.private_web)[*].id
}

output "private_app_subnet_ids" {
  description = "IDs of private application subnets."
  value       = values(aws_subnet.private_app)[*].id
}

output "private_db_subnet_ids" {
  description = "IDs of private database subnets."
  value       = values(aws_subnet.private_db)[*].id
}

output "public_route_table_id" {
  description = "Route table ID for public subnets."
  value       = aws_route_table.public.id
}
