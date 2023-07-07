locals {
  random_char_length = var.random_char_length >= 4 && var.random_char_length % 2 == 0 ? var.random_char_length / 2 : 0

  filestore_name = coalesce(var.anyscale_filestore_name, var.anyscale_filestore_name_prefix, "anyscale-")
  filestore_name_computed = var.enable_random_name_suffix ? format(
    "%s%s",
    local.filestore_name,
    random_id.random_char_suffix.hex,
  ) : local.filestore_name
  filestore_description_computed = var.anyscale_cloud_id != null ? format(
    "%s for anyscale_cloud_id: %s",
    var.filestore_description,
    var.anyscale_cloud_id,
  ) : var.filestore_description

  filestore_location_zone   = coalesce(var.filestore_location, var.google_zone, data.google_client_config.current.zone)
  filestore_location_region = coalesce(var.filestore_location, var.google_region, data.google_client_config.current.region)
  filestore_location        = var.filestore_tier == "ENTERPRISE" ? local.filestore_location_region : local.filestore_location_zone

  # fileshare_name          = coalesce(var.anyscale_filestore_fileshare_name, "anyscale")
  fileshare_name_computed = coalesce(var.anyscale_filestore_fileshare_name, "anyscale")

  module_labels = tomap({
    tf_sub_module = "google-anyscale-filestore"
  })
}

# --------------------------------------------------------------
# Random Strings for IAM Role Names
# --------------------------------------------------------------
resource "random_id" "random_char_suffix" {
  byte_length = local.random_char_length
}

# --------------------------------------------------------------
# Anyscale FileStore Resource
# --------------------------------------------------------------
resource "google_filestore_instance" "anyscale" {
  count = var.module_enabled ? 1 : 0

  name        = local.filestore_name_computed
  description = local.filestore_description_computed
  location    = local.filestore_location
  tier        = var.filestore_tier

  file_shares {
    capacity_gb = var.anyscale_filestore_fileshare_capacity_gb
    name        = local.fileshare_name_computed
  }

  networks {
    network      = var.filestore_vpc_name
    modes        = var.filestore_network_modes
    connect_mode = var.filestore_network_conect_mode
  }

  project = var.anyscale_project_id
  labels = merge(
    local.module_labels,
    var.labels
  )
}
