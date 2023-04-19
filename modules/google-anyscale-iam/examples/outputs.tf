# -------------------------------------------
# All Defaults Test
# -------------------------------------------
output "all_defaults_access_role_id" {
  description = "All Defaults - Anyscale cross account access role ID"
  value       = module.all_defaults.iam_anyscale_access_role_id
}

output "all_defaults_access_role_email" {
  description = "All Defaults - Anyscale cross account access role email"
  value       = module.all_defaults.iam_anyscale_access_role_email
}

output "all_defaults_access_role_name" {
  description = "All Defaults - Anyscale cross account access role name"
  value       = module.all_defaults.iam_anyscale_access_role_name
}

output "all_defaults_access_role_unique_id" {
  description = "All Defaults - Anyscale cross account access role unique ID"
  value       = module.all_defaults.iam_anyscale_access_role_unique_id
}

output "all_defaults_cluster_node_role_id" {
  description = "All Defaults - Anyscale cluster node role ID"
  value       = module.all_defaults.iam_anyscale_cluster_node_role_id
}

output "all_defaults_cluster_node_role_email" {
  description = "All Defaults - Anyscale cluster node role email"
  value       = module.all_defaults.iam_anyscale_cluster_node_role_email
}

output "all_defaults_cluster_node_role_name" {
  description = "All Defaults - Anyscale cluster node role name"
  value       = module.all_defaults.iam_anyscale_cluster_node_role_name
}

output "all_defaults_cluster_node_role_unique_id" {
  description = "All Defaults - Anyscale cluster node role unique ID"
  value       = module.all_defaults.iam_anyscale_cluster_node_role_unique_id
}

# -------------------------------------------
# IAM Cluster Node Only Test
# -------------------------------------------
output "iam_cluster_node_only_role_access_role_id" {
  description = "Cluster Node Only - Anyscale cross account access role ID"
  value       = module.iam_cluster_node_only_role.iam_anyscale_access_role_id
}

output "iam_cluster_node_only_role_access_role_email" {
  description = "Cluster Node Only - Anyscale cross account access role email"
  value       = module.iam_cluster_node_only_role.iam_anyscale_access_role_email
}

output "iam_cluster_node_only_role_access_role_name" {
  description = "Cluster Node Only - Anyscale cross account access role name"
  value       = module.iam_cluster_node_only_role.iam_anyscale_access_role_name
}

output "iam_cluster_node_only_role_access_role_unique_id" {
  description = "Cluster Node Only - Anyscale cross account access role unique ID"
  value       = module.iam_cluster_node_only_role.iam_anyscale_access_role_unique_id
}

output "iam_cluster_node_only_role_cluster_node_role_id" {
  description = "Cluster Node Only - Anyscale cluster node role ID"
  value       = module.iam_cluster_node_only_role.iam_anyscale_cluster_node_role_id
}

output "iam_cluster_node_only_role_cluster_node_role_email" {
  description = "Cluster Node Only - Anyscale cluster node role email"
  value       = module.iam_cluster_node_only_role.iam_anyscale_cluster_node_role_email
}

output "iam_cluster_node_only_role_cluster_node_role_name" {
  description = "Cluster Node Only - Anyscale cluster node role name"
  value       = module.iam_cluster_node_only_role.iam_anyscale_cluster_node_role_name
}

output "iam_cluster_node_only_role_cluster_node_role_unique_id" {
  description = "Cluster Node Only - Anyscale cluster node role unique ID"
  value       = module.iam_cluster_node_only_role.iam_anyscale_cluster_node_role_unique_id
}


# -------------------------------------------
# Kitchen Sink Test
# -------------------------------------------
output "kitchen_sink_access_role_id" {
  description = "Kitchen Sink - Anyscale cross account access role ID"
  value       = module.kitchen_sink.iam_anyscale_access_role_id
}

output "kitchen_sink_access_role_email" {
  description = "Kitchen Sink - Anyscale cross account access role email"
  value       = module.kitchen_sink.iam_anyscale_access_role_email
}

output "kitchen_sink_access_role_name" {
  description = "Kitchen Sink - Anyscale cross account access role name"
  value       = module.kitchen_sink.iam_anyscale_access_role_name
}

output "kitchen_sink_access_role_unique_id" {
  description = "Kitchen Sink - Anyscale cross account access role unique ID"
  value       = module.kitchen_sink.iam_anyscale_access_role_unique_id
}

output "kitchen_sink_cluster_node_role_id" {
  description = "Kitchen Sink - Anyscale cluster node role ID"
  value       = module.kitchen_sink.iam_anyscale_cluster_node_role_id
}

output "kitchen_sink_cluster_node_role_email" {
  description = "Kitchen Sink - Anyscale cluster node role email"
  value       = module.kitchen_sink.iam_anyscale_cluster_node_role_email
}

output "kitchen_sink_cluster_node_role_name" {
  description = "Kitchen Sink - Anyscale cluster node role name"
  value       = module.kitchen_sink.iam_anyscale_cluster_node_role_name
}

output "kitchen_sink_cluster_node_role_unique_id" {
  description = "Kitchen Sink - Anyscale cluster node role unique ID"
  value       = module.kitchen_sink.iam_anyscale_cluster_node_role_unique_id
}

# -----------------
# No resource test
# -----------------
output "test_no_resources" {
  description = "The outputs of the no_resource resource - should be empty"
  value       = module.test_no_resources
}
