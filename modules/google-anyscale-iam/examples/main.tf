# ---------------------------------------------------------------------------------------------------------------------
# all_defaults
#   Create IAM Roles with minimal optional parameters
# ---------------------------------------------------------------------------------------------------------------------
module "all_defaults" {
  source         = "../"
  module_enabled = true

  anyscale_project_id = var.google_project_id
  anyscale_org_id     = var.anyscale_organization_id
}

# ---------------------------------------------------------------------------------------------------------------------
# iam_cluster_node_role
#   Create the cluster node role for Anyscale with no optional parameters.
#   Set the random char length to 8
#   Do not create the access role.
# ---------------------------------------------------------------------------------------------------------------------
module "iam_cluster_node_only_role" {
  source         = "../"
  module_enabled = true

  anyscale_org_id                                = var.anyscale_organization_id
  anyscale_project_id                            = var.google_project_id
  create_anyscale_access_role                    = false
  anyscale_cluster_node_service_acct_name_prefix = "cluster-node-only-"

  random_char_length = 8
}

# ---------------------------------------------------------------------------------------------------------------------
# Kitchen Sink
#   Create all resources with all optional parameters
# ---------------------------------------------------------------------------------------------------------------------
module "kitchen_sink" {
  source         = "../"
  module_enabled = true

  random_char_length  = 6
  anyscale_org_id     = var.anyscale_organization_id
  anyscale_project_id = var.google_project_id

  enable_random_name_suffix                        = false
  anyscale_access_service_acct_name                = "kitchen-sink-role"
  anyscale_access_service_acct_description         = "Anyscale cross account access role for kitchen sink test"
  anyscale_access_service_acct_binding_permissions = ["roles/iam.serviceAccountUser"]

  existing_workload_identity_provider_name = var.existing_workload_identity_provider_name
  # workload_identity_pool_name          = "anyscale-kitchen-sink-pool"
  # workload_identity_pool_display_name  = "Anyscale kitchen sink pool"
  # workload_identity_pool_description   = "Anyscale kitchen sink pool for kitchen sink test"
  # workload_identity_pool_provider_name = "anyscale-kitchen-sink-provider"
  # anyscale_access_aws_account_id       = "623395924981"

  anyscale_cluster_node_service_acct_name        = "kitchen-sink-cluster-node-role"
  anyscale_cluster_node_service_acct_description = "Anyscale cluster node role for kitchen sink test"
  anyscale_cluster_node_service_acct_permissions = ["roles/compute.instanceAdmin.v1"]

  enable_anyscale_cluster_logging_monitoring = true
}


# ---------------------------------------------------------------------------------------------------------------------
# test_no_resources
#   Do not create any resources
# ---------------------------------------------------------------------------------------------------------------------
module "test_no_resources" {
  source         = "../"
  module_enabled = false

  anyscale_org_id     = var.anyscale_organization_id
  anyscale_project_id = var.google_project_id
}
