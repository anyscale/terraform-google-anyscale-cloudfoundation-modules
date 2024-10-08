# ----------------------------------------------
# Anyscale Control Plane Service Account
# ----------------------------------------------
output "iam_anyscale_access_service_acct_id" {
  description = "Anyscale control plane service account ID"
  value       = try(google_service_account.anyscale_access_service_acct[0].id, null)
}

output "iam_anyscale_access_service_acct_email" {
  description = "Anyscale control plane service account email"
  value       = try(google_service_account.anyscale_access_service_acct[0].email, null)
}

output "iam_anyscale_access_service_acct_name" {
  description = "Anyscale control plane service account name"
  value       = try(google_service_account.anyscale_access_service_acct[0].name, null)
}

output "iam_anyscale_access_service_acct_unique_id" {
  description = "Anyscale control plane service account unique ID"
  value       = try(google_service_account.anyscale_access_service_acct[0].unique_id, null)
}

output "iam_anyscale_access_service_acct_member" {
  description = "Anyscale control plane service account member in the form of `serviceAccount:{email}`"
  value       = try(google_service_account.anyscale_access_service_acct[0].member, null)
}

# -------------------------------------------
# Anyscale Workload Identity Pool
# -------------------------------------------
output "iam_workload_identity_pool_id" {
  description = "Anyscale control plane workload identity pool ID"
  value       = try(google_iam_workload_identity_pool.anyscale_pool[0].id, null)
}

output "iam_workload_identity_pool_name" {
  description = "Anyscale control plane workload identity pool name"
  value       = try(google_iam_workload_identity_pool.anyscale_pool[0].name, null)
}

# -------------------------------------------
# Anyscale Workload Identity Provider
# -------------------------------------------
output "iam_workload_identity_provider_id" {
  description = "Anyscale control plane workload identity provider ID"
  value       = try(google_iam_workload_identity_pool_provider.anyscale_pool[0].id, null)
}
output "iam_workload_identity_provider_name" {
  description = "Anyscale control plane workload identity provider name"
  value       = try(google_iam_workload_identity_pool_provider.anyscale_pool[0].name, null)
}

# -------------------------------------------
# Anyscale Cluster Node Service Account
# -------------------------------------------
output "iam_anyscale_cluster_node_service_acct_id" {
  description = "Anyscale data plane cluster node service account ID"
  value       = try(google_service_account.anyscale_cluster_node_service_acct[0].id, null)
}

output "iam_anyscale_cluster_node_service_acct_email" {
  description = "Anyscale data plane cluster node service account email"
  value       = try(google_service_account.anyscale_cluster_node_service_acct[0].email, null)
}

output "iam_anyscale_cluster_node_service_acct_name" {
  description = "Anyscale data plane cluster node service account name"
  value       = try(google_service_account.anyscale_cluster_node_service_acct[0].name, null)
}

output "iam_anyscale_cluster_node_service_acct_unique_id" {
  description = "Anyscale data plane cluster node service account unique ID"
  value       = try(google_service_account.anyscale_cluster_node_service_acct[0].unique_id, null)
}

output "iam_anyscale_cluster_node_service_acct_member" {
  description = "Anyscale data plane cluster node service account member  in the form of `serviceAccount:{email}`"
  value       = try(google_service_account.anyscale_cluster_node_service_acct[0].member, null)
}
