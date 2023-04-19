resource "time_sleep" "creation" {
  count = var.module_enabled ? 1 : 0

  depends_on = [
    google_compute_network.anyscale_vpc,
    google_compute_subnetwork.anyscale_public_subnet,
    google_compute_subnetwork.anyscale_private_subnet
  ]

  create_duration = "30s"
}

output "vpc_name" {
  description = "The Google VPC name"
  value       = try(google_compute_network.anyscale_vpc[0].name, "")

  depends_on = [
    time_sleep.creation
  ]
}

output "vpc_id" {
  description = "The Google VPC id"
  value       = try(google_compute_network.anyscale_vpc[0].id, "")
  depends_on = [
    time_sleep.creation
  ]
}

output "vpc_selflink" {
  description = "The Google VPC self link"
  value       = try(google_compute_network.anyscale_vpc[0].self_link, "")
  depends_on = [
    time_sleep.creation
  ]
}

output "public_subnet_name" {
  description = "The Google VPC public subnet name"
  value       = try(google_compute_subnetwork.anyscale_public_subnet[0].name, "")
  depends_on = [
    time_sleep.creation
  ]
}
output "public_subnet_id" {
  description = "The Google VPC public subnet id"
  value       = try(google_compute_subnetwork.anyscale_public_subnet[0].id, "")
}
output "public_subnet_cidr" {
  description = "The Google VPC public subnet cidr"
  value       = try(google_compute_subnetwork.anyscale_public_subnet[0].ip_cidr_range, "")
}

output "public_subnet_region" {
  description = "The Google VPC public subnet region"
  value       = try(google_compute_subnetwork.anyscale_public_subnet[0].region, "")
}

output "private_subnet_name" {
  description = "The Google VPC private subnet name"
  value       = try(google_compute_subnetwork.anyscale_private_subnet[0].name, "")
  depends_on = [
    time_sleep.creation
  ]
}
output "private_subnet_id" {
  description = "The Google VPC private subnet id"
  value       = try(google_compute_subnetwork.anyscale_private_subnet[0].id, "")
}
output "private_subnet_cidr" {
  description = "The Google VPC private subnet cidr"
  value       = try(google_compute_subnetwork.anyscale_private_subnet[0].ip_cidr_range, "")
}
output "private_subnet_region" {
  description = "The Google VPC private subnet region"
  value       = try(google_compute_subnetwork.anyscale_private_subnet[0].region, "")
}
