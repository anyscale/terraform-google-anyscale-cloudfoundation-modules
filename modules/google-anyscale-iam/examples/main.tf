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

  anyscale_org_id                        = var.anyscale_organization_id
  anyscale_project_id                    = var.google_project_id
  create_anyscale_access_role            = false
  create_anyscale_cluster_node_role      = true
  anyscale_cluster_node_role_name_prefix = "cluster-node-only-"

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

  enable_random_name_suffix                = false
  anyscale_access_role_name                = "kitchen-sink-role"
  anyscale_access_role_description         = "Anyscale cross account access role for kitchen sink test"
  anyscale_access_role_project_permissions = ["roles/editor"]
  anyscale_access_role_binding_permissions = ["roles/iam.serviceAccountUser"]

  workload_identity_pool_name          = "anyscale-kitchen-sink-pool"
  workload_identity_pool_display_name  = "Anyscale kitchen sink pool"
  workload_identity_pool_description   = "Anyscale kitchen sink pool for kitchen sink test"
  workload_identity_pool_provider_name = "anyscale-kitchen-sink-provider"
  anyscale_access_aws_account_id       = "623395924981"

  anyscale_cluster_node_role_name        = "kitchen-sink-cluster-node-role"
  anyscale_cluster_node_role_description = "Anyscale cluster node role for kitchen sink test"
  anyscale_cluster_node_role_permissions = ["roles/compute.instanceAdmin.v1"]
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
