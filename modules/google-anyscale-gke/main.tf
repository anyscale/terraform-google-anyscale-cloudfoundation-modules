locals {
  module_enabled = var.module_enabled ? true : false

  random_char_length = var.random_char_length >= 4 && var.random_char_length % 2 == 0 ? var.random_char_length / 2 : 0

  gke_name = coalesce(var.gke_cluster_name, var.gke_cluster_name_prefix, "anyscale-")
  gke_name_computed = var.enable_random_name_suffix ? format(
    "%s%s",
    local.gke_name,
    random_id.random_char_suffix.hex,
  ) : local.gke_name
  gke_description_computed = var.anyscale_cloud_id != null ? format(
    "%s for anyscale_cloud_id: %s",
    var.gke_cluster_description,
    var.anyscale_cloud_id,
  ) : var.gke_cluster_description

  gke_zone_count = length(var.gke_zones)
  gke_location = var.regional_cluster ? coalesce(
    var.gke_region, var.google_region, data.google_client_config.current.region
  ) : coalesce(var.gke_zones[0], var.google_zone, data.google_client_config.current.zone)
  gke_node_locations = var.regional_cluster ? coalescelist(
    compact(var.gke_zones),
    try(sort(random_shuffle.available_zones[0].result), [])
  ) : slice(var.gke_zones, 1, length(var.gke_zones))

  gke_autopilot_cluster_enabled = local.module_enabled && var.gke_cluster_type == "autopilot" ? true : false
  gke_standard_cluster_enabled  = local.module_enabled && var.gke_cluster_type == "standard" ? true : false

  # Autoscaling Configurations
  autoscaling_resources = var.gke_autoscaling_config.enabled ? concat(
    [
      {
        resource_type = "cpu"
        minimum       = var.gke_autoscaling_config.min_cpu_cores
        maximum       = var.gke_autoscaling_config.max_cpu_cores
      },
      {
        resource_type = "memory"
        minimum       = var.gke_autoscaling_config.min_memory_gb
        maximum       = var.gke_autoscaling_config.max_memory_gb
      }
    ],
    var.gke_autoscaling_config.gpu_resources
  ) : []

  # Get the latest master version for the region and zone if the version is set to "latest"
  master_version_regional = var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.region.latest_master_version
  master_version_zonal    = var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.zone.latest_master_version
  master_version          = var.regional_cluster ? local.master_version_regional : local.master_version_zonal
  calculated_version      = var.kubernetes_version != "latest" ? var.kubernetes_version : local.master_version

  # Maintenance Windows
  cluster_maintenance_window_is_recurring = var.maintenance_recurrence != null && var.maintenance_end_time != null ? [1] : []
  cluster_maintenance_window_is_daily     = length(local.cluster_maintenance_window_is_recurring) > 0 ? [] : [1]

  # Workload Pool
  workload_pool_identity = "${var.anyscale_project_id}.svc.id.goog"

  module_labels = merge(
    tomap({
      tf_sub_module = "google-anyscale-gke"
    }),
    var.anyscale_cloud_id != null ? { anyscale_cloud_id = var.anyscale_cloud_id } : {}
  )
}

# --------------------------------------------------------------
# Random Strings for IAM Role Names
# --------------------------------------------------------------
resource "random_id" "random_char_suffix" {
  byte_length = local.random_char_length
}

resource "random_shuffle" "available_zones" {
  count = local.gke_zone_count == 0 ? 1 : 0

  input        = data.google_compute_zones.available[0].names
  result_count = 3
}


resource "google_container_cluster" "anyscale_dataplane_standard" {
  # checkov:skip=CKV_GCP_61: VPC Flow logs not configured in this module
  # checkov:skip=CKV_GCP_65: 'RBAC Controls' not implemented in this module.
  # checkov:skip=CKV_GCP_21: Labels are implemented as an optional variable
  # checkov:skip=CKV_GCP_68: Secure Boot is the default for the autoscaling, but can be configured by the end user
  count = local.gke_standard_cluster_enabled ? 1 : 0

  name                = local.gke_name_computed
  description         = local.gke_description_computed
  resource_labels     = merge(local.module_labels, var.labels)
  deletion_protection = var.deletion_protection
  project             = var.anyscale_project_id

  location       = local.gke_location
  node_locations = local.gke_node_locations

  network    = var.gke_cluster_vpc
  subnetwork = var.gke_cluster_subnet

  private_cluster_config {
    enable_private_endpoint = var.enable_private_endpoint
    enable_private_nodes    = var.enable_private_nodes
  }

  dynamic "network_policy" {
    for_each = var.gke_network_policy != null ? [var.gke_network_policy] : []
    content {
      enabled  = cluster_network_policy.value.enabled
      provider = cluster_network_policy.value.provider
    }
  }

  dynamic "master_authorized_networks_config" {
    for_each = length(var.master_authorized_networks) > 0 ? [true] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks
        content {
          cidr_block   = lookup(cidr_blocks.value, "cidr_block", "")
          display_name = lookup(cidr_blocks.value, "display_name", "")
        }
      }
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_range_name_pods
    services_secondary_range_name = var.ip_range_name_services

    cluster_ipv4_cidr_block  = var.gke_cluster_ipv4_cidr
    services_ipv4_cidr_block = var.gke_services_range_cidr

    dynamic "additional_pod_ranges_config" {
      for_each = length(var.additional_ip_range_names_pods) != 0 ? [1] : []
      content {
        pod_range_names = var.additional_ip_range_names_pods
      }
    }
    stack_type = "IPV4" # Currently, only IPV4 is supported by Anyscale.
  }

  min_master_version = local.calculated_version
  release_channel {
    channel = var.kubernetes_release_channel
  }

  dynamic "binary_authorization" {
    for_each = var.enable_binary_authorization ? [true] : []
    content {
      evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
    }
  }
  master_auth {
    client_certificate_config {
      issue_client_certificate = var.enable_client_certificate
    }
  }

  enable_tpu = var.enable_tpu # Support for TPU

  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count       = var.default_node_pool_initial_node_count

  maintenance_policy {
    dynamic "recurring_window" {
      for_each = local.cluster_maintenance_window_is_recurring
      content {
        start_time = var.maintenance_start_time
        end_time   = var.maintenance_end_time
        recurrence = var.maintenance_recurrence
      }
    }

    dynamic "daily_maintenance_window" {
      for_each = local.cluster_maintenance_window_is_daily
      content {
        start_time = var.maintenance_start_time
      }
    }

    dynamic "maintenance_exclusion" {
      for_each = var.maintenance_exclusions
      content {
        exclusion_name = maintenance_exclusion.value.name
        start_time     = maintenance_exclusion.value.start_time
        end_time       = maintenance_exclusion.value.end_time

        dynamic "exclusion_options" {
          for_each = maintenance_exclusion.value.exclusion_scope == null ? [] : [maintenance_exclusion.value.exclusion_scope]
          content {
            scope = exclusion_options.value
          }
        }
      }
    }
  }

  workload_identity_config {
    workload_pool = local.workload_pool_identity
  }

  node_config {
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  cluster_autoscaling {

    enabled = var.gke_autoscaling_config.enabled

    dynamic "auto_provisioning_defaults" {
      for_each = var.gke_autoscaling_config.enabled ? [true] : []
      content {
        service_account = var.gke_cluster_gcp_iam_service_account
        oauth_scopes = [
          "https://www.googleapis.com/auth/cloud-platform"
        ]

        disk_size  = coalesce(var.gke_autoscaling_config.disk_size_gb, 500)
        disk_type  = coalesce(var.gke_autoscaling_config.disk_type, "pd-balanced")
        image_type = coalesce(var.gke_autoscaling_config.image_type, "COS-CONTAINERD")

        management {
          auto_repair  = var.gke_autoscaling_config.auto_repair
          auto_upgrade = var.gke_autoscaling_config.auto_upgrade
        }

        upgrade_settings {
          strategy        = lookup(var.gke_autoscaling_config, "upgrade_strategy", "SURGE")
          max_surge       = lookup(var.gke_autoscaling_config, "upgrade_strategy", "SURGE") == "SURGE" ? lookup(var.gke_autoscaling_config, "max_surge", 1) : null
          max_unavailable = lookup(var.gke_autoscaling_config, "upgrade_strategy", "SURGE") == "SURGE" ? lookup(var.gke_autoscaling_config, "max_unavailable", 0) : null

          dynamic "blue_green_settings" {
            for_each = lookup(var.gke_autoscaling_config, "upgrade_strategy", "SURGE") == "BLUE_GREEN" ? [true] : []
            content {
              node_pool_soak_duration = lookup(var.gke_autoscaling_config, "node_pool_soak_duration", null)

              standard_rollout_policy {
                batch_soak_duration = var.gke_autoscaling_config.batch_soak_duration
                batch_percentage    = lookup(var.gke_autoscaling_config, "batch_percentage", null)
                batch_node_count    = lookup(var.gke_autoscaling_config, "batch_node_count", null)
              }
            }
          }
        }

        shielded_instance_config {
          enable_secure_boot          = var.gke_autoscaling_config.secure_boot_enabled
          enable_integrity_monitoring = var.gke_autoscaling_config.integrity_monitoring_enabled
        }
      }
    }

    auto_provisioning_locations = var.gke_autoscaling_config.enabled ? local.gke_node_locations : []

    autoscaling_profile = coalesce(var.gke_autoscaling_config.autoscaling_profile, "BALANCED")

    dynamic "resource_limits" {
      for_each = local.autoscaling_resources
      content {
        resource_type = resource_limits.value["resource_type"]
        minimum       = resource_limits.value["minimum"]
        maximum       = resource_limits.value["maximum"]
      }
    }
  }

  # Setting timeouts to 45 minutes to allow for the creation of the cluster
  timeouts {
    create = lookup(var.timeouts, "create", "45m")
    update = lookup(var.timeouts, "update", "45m")
    delete = lookup(var.timeouts, "delete", "45m")
  }
}

resource "google_container_cluster" "anyscale_dataplane_autopilot" {
  count = local.gke_autopilot_cluster_enabled ? 1 : 0

  name                = local.gke_name_computed
  description         = local.gke_description_computed
  resource_labels     = merge(local.module_labels, var.labels)
  deletion_protection = var.deletion_protection
  project             = var.anyscale_project_id

  enable_autopilot = true

  network = var.gke_cluster_vpc

  workload_identity_config {
    workload_pool = local.workload_pool_identity
  }

  maintenance_policy {
    dynamic "recurring_window" {
      for_each = local.cluster_maintenance_window_is_recurring
      content {
        start_time = var.maintenance_start_time
        end_time   = var.maintenance_end_time
        recurrence = var.maintenance_recurrence
      }
    }

    dynamic "daily_maintenance_window" {
      for_each = local.cluster_maintenance_window_is_daily
      content {
        start_time = var.maintenance_start_time
      }
    }

    dynamic "maintenance_exclusion" {
      for_each = var.maintenance_exclusions
      content {
        exclusion_name = maintenance_exclusion.value.name
        start_time     = maintenance_exclusion.value.start_time
        end_time       = maintenance_exclusion.value.end_time

        dynamic "exclusion_options" {
          for_each = maintenance_exclusion.value.exclusion_scope == null ? [] : [maintenance_exclusion.value.exclusion_scope]
          content {
            scope = exclusion_options.value
          }
        }
      }
    }
  }

  min_master_version = var.kubernetes_version
}
