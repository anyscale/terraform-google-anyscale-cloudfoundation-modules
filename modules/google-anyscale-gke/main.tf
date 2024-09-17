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

  # Get the latest master version for the region and zone if the version is set to "latest"
  master_version_regional = var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.region.latest_master_version
  master_version_zonal    = var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.zone.latest_master_version
  master_version          = var.regional_cluster ? local.master_version_regional : local.master_version_zonal
  calculated_version      = var.kubernetes_version != "latest" ? var.kubernetes_version : local.master_version

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


resource "google_container_cluster" "anyscale_dataplane" {
  # checkov:skip=CKV_GCP_65: 'RBAC Controls' not implemented in this module.
  # checkov:skip=CKV_GCP_24: This check is failing to run
  # checkov:skip=CKV_GCP_69: GKE Metadata Server will be enabled on Node Pools
  count = local.module_enabled ? 1 : 0

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
    for_each = var.enable_binary_authorization ? [var.enable_binary_authorization] : []
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

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  # Setting timeouts to 45 minutes to allow for the creation of the cluster
  timeouts {
    create = lookup(var.timeouts, "create", "45m")
    update = lookup(var.timeouts, "update", "45m")
    delete = lookup(var.timeouts, "delete", "45m")
  }
}
