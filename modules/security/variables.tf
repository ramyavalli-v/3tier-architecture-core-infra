variable "name_prefix" {
  description = "Name prefix used for security resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment identifier."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for optional bastion or load balancer placement."
  type        = list(string)
}

variable "private_web_subnet_ids" {
  description = "Private web subnet IDs."
  type        = list(string)
}

variable "private_app_subnet_ids" {
  description = "Private application subnet IDs."
  type        = list(string)
}

variable "private_db_subnet_ids" {
  description = "Private database subnet IDs."
  type        = list(string)
}

variable "tags" {
  description = "Tags applied to security resources."
  type        = map(string)
}
