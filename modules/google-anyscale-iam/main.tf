locals {
  random_char_length = var.random_char_length >= 4 && var.random_char_length % 2 == 0 ? var.random_char_length / 2 : 0

  anyscale_aws_account_id = var.workload_anyscale_aws_account_id != null ? var.workload_anyscale_aws_account_id : var.anyscale_access_aws_account_id

  anyscale_access_service_acct_enabled    = var.module_enabled && var.create_anyscale_access_service_acct ? true : false
  anyscale_access_service_acct_desc_cloud = var.anyscale_cloud_id != null ? "Anyscale access service account for cloud ${var.anyscale_cloud_id} in region ${var.google_region}" : null
  anyscale_access_service_acct_desc = coalesce(
    var.anyscale_access_service_acct_description,
    local.anyscale_access_service_acct_desc_cloud,
    "Anyscale access service account"
  )
  anyscale_access_service_acct_name = coalesce(var.anyscale_access_service_acct_name, var.anyscale_access_service_acct_name_prefix, "anyscale-")
  access_acct_name_computed = var.enable_random_name_suffix ? format(
    "%s%s",
    local.anyscale_access_service_acct_name,
    random_id.random_char_suffix.hex,
  ) : local.anyscale_access_service_acct_name

  existing_provider_provided                    = var.existing_workload_identity_provider_name != null ? true : false
  create_workload_identity_pool                 = local.anyscale_access_service_acct_enabled && !local.existing_provider_provided ? true : false
  workload_identity_pool_crossacct_rolename     = "gcp_if_${var.anyscale_org_id}"
  workload_identity_pool_name_computed          = coalesce(var.workload_identity_pool_name, local.access_acct_name_computed)
  workload_identity_pool_provider_name_computed = coalesce(var.workload_identity_pool_provider_name, local.access_acct_name_computed)
}

# --------------------------------------------------------------
# Random Strings for IAM Names
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
resource "google_service_account" "anyscale_access_service_acct" {
  count = local.anyscale_access_service_acct_enabled ? 1 : 0

  account_id  = local.access_acct_name_computed
  description = local.anyscale_access_service_acct_desc
  project     = var.anyscale_project_id
}

#tfsec:ignore:google-iam-no-project-level-service-account-impersonation
# resource "google_project_iam_member" "anyscale_access_service_acct" {
#   for_each = local.anyscale_access_service_acct_enabled ? toset(var.anyscale_access_service_acct_project_permissions) : []
#   role     = each.key
#   project  = var.anyscale_project_id
#   member   = "serviceAccount:${google_service_account.anyscale_access_service_acct[0].email}"
# }
resource "google_project_iam_member" "anyscale_access_service_acct" {
  count   = local.anyscale_access_service_acct_enabled && (local.anyscale_access_serviceacct_role_enabled || var.existing_anyscale_access_role_name != null) ? 1 : 0
  role    = coalesce(google_project_iam_custom_role.anyscale_access_role[0].name, var.existing_anyscale_access_role_name)
  project = var.anyscale_project_id
  member  = google_service_account.anyscale_access_service_acct[0].member
}

#tfsec:ignore:google-iam-no-project-level-service-account-impersonation
# Add permissions to the service account that Anyscale control plane will use
resource "google_service_account_iam_member" "anyscale_access_service_acct" {
  for_each           = local.anyscale_access_service_acct_enabled ? toset(var.anyscale_access_service_acct_binding_permissions) : []
  role               = each.key
  service_account_id = google_service_account.anyscale_access_service_acct[0].name
  member             = google_service_account.anyscale_access_service_acct[0].member
}

# Identity Pool Resources
resource "google_iam_workload_identity_pool" "anyscale_pool" {
  count   = local.create_workload_identity_pool ? 1 : 0
  project = var.anyscale_project_id

  display_name = var.workload_identity_pool_display_name
  description  = var.workload_identity_pool_description

  workload_identity_pool_id = local.workload_identity_pool_name_computed
}

resource "google_iam_workload_identity_pool_provider" "anyscale_pool" {
  count   = local.create_workload_identity_pool ? 1 : 0
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

locals {
  existing_workload_identity_pool_name = local.existing_provider_provided ? regex("(.*)/providers/.*", var.existing_workload_identity_provider_name)[0] : null
  identity_pool_name                   = local.create_workload_identity_pool ? "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.anyscale_pool[0].name}/*" : local.existing_provider_provided ? "principalSet://iam.googleapis.com/${local.existing_workload_identity_pool_name}/*" : null
}

# For AWS IAM to "assume" service account
resource "google_service_account_iam_member" "anyscale_workload_identity_user" {
  count              = local.anyscale_access_service_acct_enabled ? 1 : 0
  service_account_id = google_service_account.anyscale_access_service_acct[0].name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.identity_pool_name
}

# --------------------------------------------------------------
# Cluster Service Account
#   Permission: storage admin, artifact registry read
# --------------------------------------------------------------
locals {
  cluster_node_role_enabled = var.module_enabled && var.create_anyscale_cluster_node_service_acct ? true : false

  anyscale_cluster_node_service_acct_desc_cloud = var.anyscale_cloud_id != null ? "Anyscale cluster node role for cloud ${var.anyscale_cloud_id} in region ${var.google_region}" : null
  anyscale_cluster_node_service_acct_desc = coalesce(
    var.anyscale_cluster_node_service_acct_description,
    local.anyscale_cluster_node_service_acct_desc_cloud,
    "Anyscale cluster node role"
  )
  anyscale_cluster_node_service_acct_name = coalesce(var.anyscale_cluster_node_service_acct_name, var.anyscale_cluster_node_service_acct_name_prefix, "anyscale-")
  cluster_node_role_name_computed = var.enable_random_name_suffix ? format(
    "%s%s",
    local.anyscale_cluster_node_service_acct_name,
    random_id.random_char_suffix.hex,
  ) : local.anyscale_cluster_node_service_acct_name

  cluster_node_logging_monitoring_enabled = var.module_enabled && var.enable_anyscale_cluster_logging_monitoring ? true : false
  cluster_node_roles = concat(
    local.cluster_node_logging_monitoring_enabled ? [
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter",
    ] : [],
    var.anyscale_cluster_node_service_acct_permissions
  )
}

resource "google_service_account" "anyscale_cluster_node_service_acct" {
  count = local.cluster_node_role_enabled ? 1 : 0

  account_id  = local.cluster_node_role_name_computed
  description = local.anyscale_cluster_node_service_acct_desc
  project     = var.anyscale_project_id
}

# Add permissions to the service account that Anyscale dataplane will use
resource "google_project_iam_member" "anyscale_cluster_node_service_acct" {
  for_each = local.cluster_node_role_enabled ? toset(local.cluster_node_roles) : []
  role     = each.key
  project  = var.anyscale_project_id
  member   = google_service_account.anyscale_cluster_node_service_acct[0].member
}

resource "google_service_account_iam_member" "anyscale_cluster_node_service_acct" {
  count              = local.cluster_node_role_enabled && local.anyscale_access_service_acct_enabled ? 1 : 0
  role               = "roles/iam.serviceAccountUser"
  service_account_id = google_service_account.anyscale_cluster_node_service_acct[0].name
  member             = google_service_account.anyscale_access_service_acct[0].member
}
