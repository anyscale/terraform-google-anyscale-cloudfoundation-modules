# -------------------------------------------
# Anyscale Cross Account Access Role
# -------------------------------------------
output "iam_anyscale_access_role_id" {
  description = "Anyscale cross account access role ID"
  value       = try(google_service_account.anyscale_access_role[0].id, null)
}

output "iam_anyscale_access_role_email" {
  description = "Anyscale cross account access role email"
  value       = try(google_service_account.anyscale_access_role[0].email, null)
}

output "iam_anyscale_access_role_name" {
  description = "Anyscale cross account access role name"
  value       = try(google_service_account.anyscale_access_role[0].name, null)
}

output "iam_anyscale_access_role_unique_id" {
  description = "Anyscale cross account access role unique ID"
  value       = try(google_service_account.anyscale_access_role[0].unique_id, null)
}

# -------------------------------------------
# Anyscale Workload Identity Pool
# -------------------------------------------
output "iam_workload_identity_pool_id" {
  description = "Anyscale cross account workload identity pool ID"
  value       = try(google_iam_workload_identity_pool.anyscale_pool[0].id, null)
}

output "iam_workload_identity_pool_name" {
  description = "Anyscale cross account workload identity pool name"
  value       = try(google_iam_workload_identity_pool.anyscale_pool[0].name, null)
}

# -------------------------------------------
# Anyscale Workload Identity Provider
# -------------------------------------------
output "iam_workload_identity_provider_id" {
  description = "Anyscale cross account workload identity provider ID"
  value       = try(google_iam_workload_identity_pool_provider.anyscale_pool[0].id, null)
}
output "iam_workload_identity_provider_name" {
  description = "Anyscale cross account workload identity provider name"
  value       = try(google_iam_workload_identity_pool_provider.anyscale_pool[0].name, null)
}

# -------------------------------------------
# Anyscale Cluster Node Role
# -------------------------------------------
output "iam_anyscale_cluster_node_role_id" {
  description = "Anyscale cross account cluster node role ID"
  value       = try(google_service_account.anyscale_cluster_node_role[0].id, null)
}

output "iam_anyscale_cluster_node_role_email" {
  description = "Anyscale cross account cluster node role email"
  value       = try(google_service_account.anyscale_cluster_node_role[0].email, null)
}

output "iam_anyscale_cluster_node_role_name" {
  description = "Anyscale cross account cluster node role name"
  value       = try(google_service_account.anyscale_cluster_node_role[0].name, null)
}

output "iam_anyscale_cluster_node_role_unique_id" {
  description = "Anyscale cross account cluster node role unique ID"
  value       = try(google_service_account.anyscale_cluster_node_role[0].unique_id, null)
}
