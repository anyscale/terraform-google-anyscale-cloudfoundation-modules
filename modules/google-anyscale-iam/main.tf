locals {
  random_char_length = var.random_char_length >= 4 && var.random_char_length % 2 == 0 ? var.random_char_length / 2 : 0

  anyscale_aws_account_id      = var.workload_anyscale_aws_account_id != null ? var.workload_anyscale_aws_account_id : var.anyscale_access_aws_account_id
  anyscale_access_role_enabled = var.module_enabled && var.create_anyscale_access_role ? true : false

  anyscale_access_role_desc_cloud = var.anyscale_cloud_id != null ? "Anyscale access role for cloud ${var.anyscale_cloud_id} in region ${var.google_region}" : null
  anyscale_access_role_desc = coalesce(
    var.anyscale_access_role_description,
    local.anyscale_access_role_desc_cloud,
    "Anyscale access role"
  )
  anyscale_access_role_name = coalesce(var.anyscale_access_role_name, var.anyscale_access_role_name_prefix, "anyscale-")
  access_role_name_computed = var.enable_random_name_suffix ? format(
    "%s%s",
    local.anyscale_access_role_name,
    random_id.random_char_suffix.hex,
  ) : local.anyscale_access_role_name

  workload_identity_pool_crossacct_rolename     = "gcp_if_${var.anyscale_org_id}"
  workload_identity_pool_name_computed          = coalesce(var.workload_identity_pool_name, local.access_role_name_computed)
  workload_identity_pool_provider_name_computed = coalesce(var.workload_identity_pool_provider_name, local.access_role_name_computed)
}

# --------------------------------------------------------------
# Random Strings for IAM Role Names
# --------------------------------------------------------------
resource "random_id" "random_char_suffix" {
  byte_length = local.random_char_length
}

# --------------------------------------------------------------
# Sercvice Account for Anyscale Cross Account Access
#   Permission:
#     Project owner Role
#     serviceAccountTokenCreator
#     workloadIdentityUser
# --------------------------------------------------------------
resource "google_service_account" "anyscale_access_role" {
  count = local.anyscale_access_role_enabled ? 1 : 0

  account_id  = local.access_role_name_computed
  description = local.anyscale_access_role_desc
  project     = var.anyscale_project_id
}

#tfsec:ignore:google-iam-no-project-level-service-account-impersonation
resource "google_project_iam_binding" "anyscale_access_role" {
  for_each = local.anyscale_access_role_enabled ? toset(var.anyscale_access_role_project_permissions) : []
  role     = each.key
  project  = var.anyscale_project_id
  members  = ["serviceAccount:${google_service_account.anyscale_access_role[0].email}"]
}

#tfsec:ignore:google-iam-no-project-level-service-account-impersonation
resource "google_service_account_iam_binding" "anyscale_access_role" {
  for_each           = local.anyscale_access_role_enabled ? toset(var.anyscale_access_role_binding_permissions) : []
  role               = each.key
  service_account_id = google_service_account.anyscale_access_role[0].name
  members            = ["serviceAccount:${google_service_account.anyscale_access_role[0].email}"]
}

resource "google_iam_workload_identity_pool" "anyscale_pool" {
  count   = local.anyscale_access_role_enabled ? 1 : 0
  project = var.anyscale_project_id

  display_name = var.workload_identity_pool_display_name
  description  = var.workload_identity_pool_description

  workload_identity_pool_id = local.workload_identity_pool_name_computed
}

resource "google_iam_workload_identity_pool_provider" "anyscale_pool" {
  count   = local.anyscale_access_role_enabled ? 1 : 0
  project = var.anyscale_project_id

  workload_identity_pool_id          = google_iam_workload_identity_pool.anyscale_pool[0].workload_identity_pool_id
  workload_identity_pool_provider_id = local.workload_identity_pool_provider_name_computed

  display_name = var.workload_identity_pool_display_name
  description  = var.workload_identity_pool_description

  attribute_mapping = {
    "google.subject"     = "assertion.arn"
    "attribute.aws_role" = "assertion.arn.contains('assumed-role') ? assertion.arn.extract('{account_arn}assumed-role/') + 'assumed-role/' + assertion.arn.extract('assumed-role/{role_name}/') : assertion.arn"
    "attribute.arn"      = "assertion.arn"
  }

  attribute_condition = "google.subject.startsWith(\"arn:aws:sts::${local.anyscale_aws_account_id}:assumed-role/${local.workload_identity_pool_crossacct_rolename}\")"

  aws {
    account_id = local.anyscale_aws_account_id
  }
}

resource "google_service_account_iam_binding" "anyscale_workload_identity_user" {
  count = local.anyscale_access_role_enabled ? 1 : 0

  service_account_id = google_service_account.anyscale_access_role[0].name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.anyscale_pool[0].name}/*"
  ]
}

# --------------------------------------------------------------
# Cluster Service Account
#   Permission: storage admin, artifact registry read
# --------------------------------------------------------------
locals {
  cluster_node_role_enabled = var.module_enabled && var.create_anyscale_cluster_node_role ? true : false

  anyscale_cluster_node_role_desc_cloud = var.anyscale_cloud_id != null ? "Anyscale cluster node role for cloud ${var.anyscale_cloud_id} in region ${var.google_region}" : null
  anyscale_cluster_node_role_desc = coalesce(
    var.anyscale_cluster_node_role_description,
    local.anyscale_cluster_node_role_desc_cloud,
    "Anyscale cluster node role"
  )
  anyscale_cluster_node_role_name = coalesce(var.anyscale_cluster_node_role_name, var.anyscale_cluster_node_role_name_prefix, "anyscale-")
  cluster_node_role_name_computed = var.enable_random_name_suffix ? format(
    "%s%s",
    local.anyscale_cluster_node_role_name,
    random_id.random_char_suffix.hex,
  ) : local.anyscale_cluster_node_role_name
}

resource "google_service_account" "anyscale_cluster_node_role" {
  count = local.cluster_node_role_enabled ? 1 : 0

  account_id  = local.cluster_node_role_name_computed
  description = local.anyscale_cluster_node_role_desc
  project     = var.anyscale_project_id
}

resource "google_project_iam_binding" "anyscale_cluster_node_role" {
  for_each = local.cluster_node_role_enabled ? toset(var.anyscale_cluster_node_role_permissions) : []
  role     = each.key
  project  = var.anyscale_project_id
  # service_account_id = google_service_account.anyscale_cluster_node_role[0].name
  members = ["serviceAccount:${google_service_account.anyscale_cluster_node_role[0].email}"]
}
