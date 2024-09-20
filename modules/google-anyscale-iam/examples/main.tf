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
# iam_gke_cluster_role
#   Create the GKE Cluster role for Anyscale with no optional parameters.
#   Set the random char length to 8
#   Do not create the access role.
#   Do not create the cluster node role.
# ---------------------------------------------------------------------------------------------------------------------
module "iam_gke_cluster_only_role" {
  source         = "../"
  module_enabled = true

  anyscale_org_id                           = var.anyscale_organization_id
  anyscale_project_id                       = var.google_project_id
  create_anyscale_access_role               = false
  create_anyscale_cluster_node_service_acct = false

  create_gke_cluster_service_acct      = true
  gke_cluster_service_acct_name_prefix = "gke-cluster-only-"

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
  anyscale_access_service_acct_name                = "kitchen-sink-sa"
  anyscale_access_service_acct_description         = "Anyscale cross account access Service Account for kitchen sink test"
  anyscale_access_service_acct_binding_permissions = ["roles/iam.serviceAccountUser"]

  anyscale_access_role_id = "kitchen_sink_role"

  existing_workload_identity_provider_name = var.existing_workload_identity_provider_name

  anyscale_cluster_node_service_acct_name        = "kitchen-sink-cluster-node-sa"
  anyscale_cluster_node_service_acct_description = "Anyscale cluster node Service Account for kitchen sink test"
  anyscale_cluster_node_service_acct_permissions = ["roles/compute.instanceAdmin.v1"]

  enable_anyscale_cluster_logging_monitoring = true

  create_gke_cluster_service_acct      = true
  gke_cluster_service_acct_name        = "kitchen-sink-gke-cluster-sa"
  gke_cluster_service_acct_description = "Anyscale GKE cluster Service Account for kitchen sink test"
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
