locals {
  project_folder_id = var.folder_id != null ? var.folder_id : null
  project_org_id    = var.folder_id != null ? null : var.organization_id

  project_name       = coalesce(var.anyscale_project_name, var.anyscale_project_name_prefix, "anyscale-")
  project_id         = coalesce(var.anyscale_project_id, local.project_name)
  random_char_length = var.random_char_length >= 4 && var.random_char_length % 2 == 0 ? var.random_char_length / 2 : 0

  computed_project_name = var.enable_random_name_suffix ? format(
    "%s%s",
    local.project_name,
    random_id.random_char_suffix.hex,
  ) : local.project_name
  computed_project_id = var.enable_random_name_suffix ? format(
    "%s%s",
    local.project_id,
    random_id.random_char_suffix.hex,
  ) : local.project_id

  module_labels = tomap({
    tf_sub_module = "google-anyscale-project"
  })
}


#-------------------------------
# Random Strings for Project ID
#-------------------------------
resource "random_id" "random_char_suffix" {
  byte_length = local.random_char_length
}

#-------------------------------
# Google Project Resource
#-------------------------------
resource "google_project" "anyscale_project" {
  count = var.module_enabled ? 1 : 0

  name       = local.computed_project_name
  project_id = local.computed_project_id

  org_id          = local.project_org_id
  folder_id       = local.project_folder_id
  billing_account = var.billing_account_id

  auto_create_network = false

  labels = merge(
    var.labels,
    local.module_labels
  )
}

resource "google_project_iam_audit_config" "anyscale_project_audit_config" {
  count = var.module_enabled ? 1 : 0

  project = google_project.anyscale_project[0].id
  service = "allServices"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
}
