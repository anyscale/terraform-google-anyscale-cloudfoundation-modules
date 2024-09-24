# -------------------------------------------
# All Defaults Test
# -------------------------------------------
output "all_defaults_access_role_id" {
  description = "All Defaults - Anyscale cross account access Service Account ID"
  value       = module.all_defaults.iam_anyscale_access_service_acct_id
}

output "all_defaults_access_role_email" {
  description = "All Defaults - Anyscale cross account access Service Account email"
  value       = module.all_defaults.iam_anyscale_access_service_acct_email
}

output "all_defaults_access_role_name" {
  description = "All Defaults - Anyscale cross account access Service Account name"
  value       = module.all_defaults.iam_anyscale_access_service_acct_name
}

output "all_defaults_access_role_unique_id" {
  description = "All Defaults - Anyscale cross account access Service Account unique ID"
  value       = module.all_defaults.iam_anyscale_access_service_acct_unique_id
}

output "all_defaults_cluster_node_service_acct_id" {
  description = "All Defaults - Anyscale cluster node Service Account ID"
  value       = module.all_defaults.iam_anyscale_cluster_node_service_acct_id
}

output "all_defaults_cluster_node_service_acct_email" {
  description = "All Defaults - Anyscale cluster node Service Account email"
  value       = module.all_defaults.iam_anyscale_cluster_node_service_acct_email
}

output "all_defaults_cluster_node_service_acct_name" {
  description = "All Defaults - Anyscale cluster node Service Account name"
  value       = module.all_defaults.iam_anyscale_cluster_node_service_acct_name
}

output "all_defaults_cluster_node_service_acct_unique_id" {
  description = "All Defaults - Anyscale cluster node Service Account unique ID"
  value       = module.all_defaults.iam_anyscale_cluster_node_service_acct_unique_id
}

# -------------------------------------------
# IAM Cluster Node Only Test
# -------------------------------------------
output "iam_cluster_node_only_role_access_role_id" {
  description = "Cluster Node Only - Anyscale cross account access Service Account ID"
  value       = module.iam_cluster_node_only_role.iam_anyscale_access_service_acct_id
}

output "iam_cluster_node_only_role_access_role_email" {
  description = "Cluster Node Only - Anyscale cross account access Service Account email"
  value       = module.iam_cluster_node_only_role.iam_anyscale_access_service_acct_email
}

output "iam_cluster_node_only_role_access_role_name" {
  description = "Cluster Node Only - Anyscale cross account access Service Account name"
  value       = module.iam_cluster_node_only_role.iam_anyscale_access_service_acct_name
}

output "iam_cluster_node_only_role_access_role_unique_id" {
  description = "Cluster Node Only - Anyscale cross account access Service Account unique ID"
  value       = module.iam_cluster_node_only_role.iam_anyscale_access_service_acct_unique_id
}

output "iam_cluster_node_only_role_cluster_node_service_acct_id" {
  description = "Cluster Node Only - Anyscale cluster node Service Account ID"
  value       = module.iam_cluster_node_only_role.iam_anyscale_cluster_node_service_acct_id
}

output "iam_cluster_node_only_role_cluster_node_service_acct_email" {
  description = "Cluster Node Only - Anyscale cluster node Service Account email"
  value       = module.iam_cluster_node_only_role.iam_anyscale_cluster_node_service_acct_email
}

output "iam_cluster_node_only_role_cluster_node_service_acct_name" {
  description = "Cluster Node Only - Anyscale cluster node Service Account name"
  value       = module.iam_cluster_node_only_role.iam_anyscale_cluster_node_service_acct_name
}

output "iam_cluster_node_only_role_cluster_node_service_acct_unique_id" {
  description = "Cluster Node Only - Anyscale cluster node Service Account unique ID"
  value       = module.iam_cluster_node_only_role.iam_anyscale_cluster_node_service_acct_unique_id
}

# -------------------------------------------
# GKE Cluster Role Test
# -------------------------------------------
output "iam_gke_cluster_only_role_outputs" {
  description = "GKE Cluster Only Outputs"
  value       = module.iam_gke_cluster_only_role
}


# -------------------------------------------
# Kitchen Sink Test
# -------------------------------------------
output "kitchen_sink_access_role_id" {
  description = "Kitchen Sink - Anyscale cross account access Service Account ID"
  value       = module.kitchen_sink.iam_anyscale_access_service_acct_id
}

output "kitchen_sink_access_role_email" {
  description = "Kitchen Sink - Anyscale cross account access Service Account email"
  value       = module.kitchen_sink.iam_anyscale_access_service_acct_email
}

output "kitchen_sink_access_role_name" {
  description = "Kitchen Sink - Anyscale cross account access Service Account name"
  value       = module.kitchen_sink.iam_anyscale_access_service_acct_name
}

output "kitchen_sink_access_role_unique_id" {
  description = "Kitchen Sink - Anyscale cross account access Service Account unique ID"
  value       = module.kitchen_sink.iam_anyscale_access_service_acct_unique_id
}

output "kitchen_sink_cluster_node_service_acct_id" {
  description = "Kitchen Sink - Anyscale cluster node Service Account ID"
  value       = module.kitchen_sink.iam_anyscale_cluster_node_service_acct_id
}

output "kitchen_sink_cluster_node_service_acct_email" {
  description = "Kitchen Sink - Anyscale cluster node Service Account email"
  value       = module.kitchen_sink.iam_anyscale_cluster_node_service_acct_email
}

output "kitchen_sink_cluster_node_service_acct_name" {
  description = "Kitchen Sink - Anyscale cluster node Service Account name"
  value       = module.kitchen_sink.iam_anyscale_cluster_node_service_acct_name
}

output "kitchen_sink_cluster_node_service_acct_unique_id" {
  description = "Kitchen Sink - Anyscale cluster node Service Account unique ID"
  value       = module.kitchen_sink.iam_anyscale_cluster_node_service_acct_unique_id
}

# -----------------
# No resource test
# -----------------
output "test_no_resources" {
  description = "The outputs of the no_resource resource - should be empty"
  value       = module.test_no_resources
}
