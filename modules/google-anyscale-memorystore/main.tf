locals {
  random_char_length = var.random_char_length >= 4 && var.random_char_length % 2 == 0 ? var.random_char_length / 2 : 0

  memorystore_name = coalesce(var.anyscale_memorystore_name, var.anyscale_memorystore_name_prefix, "anyscale-memorystore-")
  memorystore_name_computed = var.enable_random_name_suffix ? format(
    "%s%s",
    local.memorystore_name,
    random_id.random_char_suffix.hex,
  ) : local.memorystore_name

  module_labels = tomap({
    tf_sub_module = "google-anyscale-memorystore"
  })
}

# --------------------------------------------------------------
# Random strings for resource names
# --------------------------------------------------------------
resource "random_id" "random_char_suffix" {
  byte_length = local.random_char_length
}

# --------------------------------------------------------------
# Anyscale Memorystore Resource
# --------------------------------------------------------------
resource "google_redis_instance" "anyscale_memorystore" {
  #checkov:skip=CKV_GCP_97:Google Memorystore Encryption is managed via variable
  #checkov:skip=CKV_GCP_95:Google Memorystore Encryption auth is not required for Anyscale Services
  count = var.module_enabled ? 1 : 0

  name               = local.memorystore_name_computed
  tier               = var.memorystore_tier
  replica_count      = var.memorystore_tier == "STANDARD_HA" ? var.memorystore_replica_count : null
  read_replicas_mode = var.memorystore_tier == "STANDARD_HA" ? var.memorystore_replica_mode : null
  memory_size_gb     = var.memorystore_memory_size_gb
  connect_mode       = var.memorystore_connect_mode
  authorized_network = var.memorystore_vpc_name

  region                  = var.google_region
  location_id             = var.google_zone
  alternative_location_id = var.alternative_google_zone

  redis_version = var.memorystore_redis_version
  redis_configs = var.memorystore_redis_configs
  display_name  = var.memorystore_display_name

  auth_enabled            = var.memorystore_enable_auth
  transit_encryption_mode = var.memorystore_encryption_mode

  dynamic "maintenance_policy" {
    for_each = var.memorystore_maintenance_policy != null ? [var.memorystore_maintenance_policy] : []
    content {
      weekly_maintenance_window {
        day = maintenance_policy.value["day"]
        start_time {
          hours   = maintenance_policy.value["start_time"]["hours"]
          minutes = maintenance_policy.value["start_time"]["minutes"]
          seconds = maintenance_policy.value["start_time"]["seconds"]
          nanos   = maintenance_policy.value["start_time"]["nanos"]
        }
      }
    }
  }

  dynamic "persistence_config" {
    for_each = var.memorystore_persistence_config != null ? [var.memorystore_persistence_config] : []
    content {
      persistence_mode    = persistence_config.value["persistence_mode"]
      rdb_snapshot_period = persistence_config.value["rdb_snapshot_period"]
    }
  }

  project = var.anyscale_project_id
  labels = merge(
    local.module_labels,
    var.labels
  )
}
