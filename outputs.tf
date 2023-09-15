# ------------------------------------
# Google Project Outputs
# ------------------------------------
output "project_name" {
  description = "The Google Project name."
  value       = try(module.google_anyscale_project.project_name, "")
}
output "project_id" {
  description = "The Google Project id."
  value       = try(module.google_anyscale_project.project_id, "")
}

# ------------------------------------
# VPC Resource Outputs
# ------------------------------------
output "vpc_name" {
  description = "The Google VPC network name."
  value       = try(module.google_anyscale_vpc.vpc_name, "")
}
output "vpc_id" {
  description = "The Google VPC id."
  value       = try(module.google_anyscale_vpc.vpc_id, "")
}
output "vpc_selflink" {
  description = "The Google VPC self link."
  value       = try(module.google_anyscale_vpc.vpc_selflink, "")
}
output "public_subnet_name" {
  description = "The Google VPC public subnet name."
  value       = try(module.google_anyscale_vpc.public_subnet_name, "")
}
output "public_subnet_id" {
  description = "The Google VPC public subnet id."
  value       = try(module.google_anyscale_vpc.public_subnet_id, "")
}
output "public_subnet_cidr" {
  description = "The Google VPC public subnet cidr."
  value       = try(module.google_anyscale_vpc.public_subnet_cidr, "")
}
output "public_subnet_region" {
  description = "The Google VPC public subnet region."
  value       = try(module.google_anyscale_vpc.public_subnet_region, "")
}
output "private_subnet_name" {
  description = "The Google VPC private subnet name."
  value       = try(module.google_anyscale_vpc.private_subnet_name, "")
}
output "private_subnet_id" {
  description = "The Google VPC private subnet id."
  value       = try(module.google_anyscale_vpc.private_subnet_id, "")
}
output "private_subnet_cidr" {
  description = "The Google VPC private subnet cidr."
  value       = try(module.google_anyscale_vpc.private_subnet_cidr, "")
}
output "private_subnet_region" {
  description = "The Google VPC private subnet region."
  value       = try(module.google_anyscale_vpc.private_subnet_region, "")
}
# ------------------------------------
# VPC Firewall Policy Outputs
# ------------------------------------
output "vpc_firewall_policy_name" {
  description = "The Google VPC firewall policy name."
  value       = try(module.google_anyscale_vpc_firewall_policy.vpc_firewall_policy_name, "")
}
output "vpc_firewall_id" {
  description = "The Google VPC firewall policy id."
  value       = try(module.google_anyscale_vpc_firewall_policy.vpc_firewall_id, "")
}
output "vpc_firewall_selflink" {
  description = "The Google VPC firewall policy self link."
  value       = try(module.google_anyscale_vpc_firewall_policy.vpc_firewall_selflink, "")
}

# ------------------------------------
# Cloud Storage Resource Outputs
# ------------------------------------
output "cloudstorage_bucket_name" {
  description = "The Google Cloud Storage bucket name."
  value       = try(module.google_anyscale_cloudstorage.cloudstorage_bucket_name, "")
}

output "cloudstorage_bucket_selflink" {
  description = "The Google Cloud Storage self link."
  value       = try(module.google_anyscale_cloudstorage.cloudstorage_bucket_selflink, "")
}

output "cloudstorage_bucket_url" {
  description = "The Google Cloud Storage url for the bucket. Will be in the format `gs://<bucket-name>`."
  value       = try(module.google_anyscale_cloudstorage.cloudstorage_bucket_url, var.existing_cloudstorage_bucket_name, "")
}

# ------------------------------------
# Filestore Resource Outputs
# ------------------------------------
output "filestore_name" {
  description = "The Google Filestore name."
  value       = try(module.google_anyscale_filestore.anyscale_filestore_name, "")
}
output "filestore_id" {
  description = "The Google Filestore id."
  value       = try(module.google_anyscale_filestore.anyscale_filestore_id, "")
}
output "filestore_location" {
  description = "The Google Filestore location."
  value       = try(module.google_anyscale_filestore.anyscale_filestore_location, "")
}
output "filestore_fileshare_name" {
  description = "The Google Filestore fileshare name."
  value       = try(module.google_anyscale_filestore.anyscale_filestore_fileshare_name, "")
}

# ------------------------------------
# IAM Resource Outputs
# ------------------------------------
output "iam_anyscale_access_role_id" {
  description = "The Google IAM Anyscale Access Role id."
  value       = try(module.google_anyscale_iam.iam_anyscale_access_role_id, "")
}
output "iam_anyscale_access_role_name" {
  description = "The Google IAM Anyscale Access Role name."
  value       = try(module.google_anyscale_iam.iam_anyscale_access_role_name, "")
}
output "iam_anyscale_access_role_email" {
  description = "The Google IAM Anyscale Access Role email."
  value       = try(module.google_anyscale_iam.iam_anyscale_access_role_email, "")
}
output "iam_anyscale_access_role_unique_id" {
  description = "The Google IAM Anyscale Access Role unique id."
  value       = try(module.google_anyscale_iam.iam_anyscale_access_role_unique_id, "")
}

output "iam_workload_identity_pool_id" {
  description = "The Google IAM Anyscale Workload Identity Pool id."
  value       = try(module.google_anyscale_iam.iam_workload_identity_pool_id, "")
}
output "iam_workload_identity_pool_name" {
  description = "The Google IAM Anyscale Workload Identity Pool name."
  value       = try(module.google_anyscale_iam.iam_workload_identity_pool_name, "")
}
output "iam_workload_identity_provider_id" {
  description = "The Google IAM Anyscale Workload Identity Provider id."
  value       = try(module.google_anyscale_iam.iam_workload_identity_provider_id, "")
}
output "iam_workload_identity_provider_name" {
  description = "The Google IAM Anyscale Workload Identity Provider name."
  value       = try(module.google_anyscale_iam.iam_workload_identity_provider_name, "")
}

output "iam_anyscale_cluster_node_role_id" {
  description = "The Google IAM Anyscale Cluster Node Role id."
  value       = try(module.google_anyscale_iam.iam_anyscale_cluster_node_role_id, "")
}
output "iam_anyscale_cluster_node_role_name" {
  description = "The Google IAM Anyscale Cluster Node Role name."
  value       = try(module.google_anyscale_iam.iam_anyscale_cluster_node_role_name, "")
}
output "iam_anyscale_cluster_node_role_email" {
  description = "The Google IAM Anyscale Cluster Node Role email."
  value       = try(module.google_anyscale_iam.iam_anyscale_cluster_node_role_email, "")
}
output "iam_anyscale_cluster_node_role_unique_id" {
  description = "The Google IAM Anyscale Cluster Node Role unique id."
  value       = try(module.google_anyscale_iam.iam_anyscale_cluster_node_role_unique_id, "")
}

# ------------------------------------
# Memorystore Resource Outputs
# ------------------------------------
output "memorystore_id" {
  description = "The memorystore instance ID."
  value       = try(module.google_anyscale_memorystore.anyscale_memorystore_id, "")
}

output "memorystore_host" {
  description = "The IP address of the instance."
  value       = try(module.google_anyscale_memorystore.anyscale_memorystore_host, "")
}

output "memorystore_port" {
  description = "The port number of the exposed Redis endpoint."
  value       = try(module.google_anyscale_memorystore.anyscale_memorystore_port, "")
}

output "memorystore_region" {
  description = "The region the instance lives in."
  value       = try(module.google_anyscale_memorystore.anyscale_memorystore_region, "")
}

output "memorystore_current_location_id" {
  description = "The current zone where the Redis endpoint is placed."
  value       = try(module.google_anyscale_memorystore.anyscale_memorystore[0].current_location_id, "")
}
