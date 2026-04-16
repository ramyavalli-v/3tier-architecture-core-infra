variable "name_prefix" {
  description = "Name prefix used for resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment identifier."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "Availability zones for subnet placement."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Create a NAT Gateway for private subnets."
  type        = bool
}

variable "tags" {
  description = "Tags applied to network resources."
  type        = map(string)
}
