# -----------------------------------------------------
# All Defaults Test
# -----------------------------------------------------
output "all_defaults_name" {
  description = "all_defaults VPC name"
  value       = module.all_defaults.vpc_name
}
output "all_defaults_id" {
  description = "all_defaults VPC id"
  value       = module.all_defaults.vpc_id
}
output "all_defaults_selflink" {
  description = "all_defaults VPC cidr"
  value       = module.all_defaults.vpc_selflink
}

# -----------------------------------------------------
# Minimum VPC - Public Subnet Test
# -----------------------------------------------------
output "minimum_vpc_public_name" {
  description = "minimum_vpc_public_subnet_name VPC name"
  value       = module.minimum_anyscale_vpc_requirements_public.vpc_name
}
output "minimum_vpc_public_id" {
  description = "minimum_vpc_public_subnet_id VPC id"
  value       = module.minimum_anyscale_vpc_requirements_public.vpc_id
}
output "minimum_vpc_public_subnet_selflink" {
  description = "minimum_vpc_public_subnet_selflink VPC cidr"
  value       = module.minimum_anyscale_vpc_requirements_public.vpc_selflink
}
output "minimum_vpc_public_subnet_name" {
  description = "minimum_vpc_public_subnet_name VPC name"
  value       = module.minimum_anyscale_vpc_requirements_public.vpc_name
}
output "minimum_vpc_public_subnet_id" {
  description = "minimum_vpc_public_subnet_id VPC id"
  value       = module.minimum_anyscale_vpc_requirements_public.vpc_id
}
output "minimum_vpc_public_subnet_cidr" {
  description = "minimum_vpc_public_subnet_cidr VPC cidr"
  value       = module.minimum_anyscale_vpc_requirements_public.public_subnet_cidr
}

# -----------------------------------------------------
# Minimum VPC - Private Subnet Test
# -----------------------------------------------------
output "minimum_vpc_private_name" {
  description = "minimum_vpc_private_subnet_name VPC name"
  value       = module.minimum_anyscale_vpc_requirements_private.vpc_name
}
output "minimum_vpc_private_id" {
  description = "minimum_vpc_private_subnet_id VPC id"
  value       = module.minimum_anyscale_vpc_requirements_private.vpc_id
}
output "minimum_vpc_private_subnet_selflink" {
  description = "minimum_vpc_private_subnet_selflink VPC cidr"
  value       = module.minimum_anyscale_vpc_requirements_private.vpc_selflink
}
output "minimum_vpc_private_subnet_name" {
  description = "minimum_vpc_private_subnet_name VPC name"
  value       = module.minimum_anyscale_vpc_requirements_private.vpc_name
}
output "minimum_vpc_private_subnet_id" {
  description = "minimum_vpc_private_subnet_id VPC id"
  value       = module.minimum_anyscale_vpc_requirements_private.vpc_id
}
output "minimum_vpc_private_subnet_cidr" {
  description = "minimum_vpc_private_subnet_cidr VPC cidr"
  value       = module.minimum_anyscale_vpc_requirements_private.private_subnet_cidr
}

# -----------------------------------------------------
# No Resources Test
# -----------------------------------------------------
output "test_no_resources" {
  description = "The outputs of the no_resource resource - should all be empty"
  value       = module.test_no_resources
}
