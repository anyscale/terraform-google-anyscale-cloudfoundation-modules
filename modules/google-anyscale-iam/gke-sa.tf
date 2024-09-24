# --------------------------------------------------------------
# GKE Cluster Service Account
# --------------------------------------------------------------
locals {
  gke_cluster_sa_enabled = var.module_enabled && var.create_gke_cluster_service_acct ? true : false

  gke_cluster_sa_desc_cloud = var.anyscale_cloud_id != null ? "Anyscale GKE cluster Service Account ${var.anyscale_cloud_id} in region ${var.google_region}" : null
  gke_cluster_sa_desc = coalesce(
    var.gke_cluster_service_acct_description,
    local.gke_cluster_sa_desc_cloud,
    "Anyscale GKE cluster Service Account"
  )
  gke_cluster_sa_name = coalesce(var.gke_cluster_service_acct_name, var.gke_cluster_service_acct_name_prefix, "anyscale-")
  gke_cluster_sa_name_computed = var.enable_random_name_suffix ? format(
    "%s%s",
    local.gke_cluster_sa_name,
    random_id.random_char_suffix.hex,
  ) : local.gke_cluster_sa_name

  gke_logging_monitoring_enabled = var.module_enabled && var.enable_gke_cluster_logging_monitoring ? true : false
  gke_cluster_roles = concat(
    local.gke_logging_monitoring_enabled ? [
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter",
    ] : [],
    var.gke_cluster_service_acct_permissions
  )
}

resource "google_service_account" "gke_cluster_service_account" {
  count = local.gke_cluster_sa_enabled ? 1 : 0

  account_id  = local.gke_cluster_sa_name_computed
  description = local.gke_cluster_sa_desc
  project     = var.anyscale_project_id
}

resource "google_project_iam_member" "gke_cluster_service_account" {
  for_each = local.gke_cluster_sa_enabled ? toset(local.gke_cluster_roles) : []
  role     = each.key
  project  = var.anyscale_project_id
  member   = google_service_account.gke_cluster_service_account[0].member
}
