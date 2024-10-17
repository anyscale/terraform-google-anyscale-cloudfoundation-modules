# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ------------------------------------------------------------------------------
variable "gke_cluster_vpc" {
  description = <<-EOT
    (Required) The name of the VPC to which the filestore is attached.

    ex:
    ```
    gke_cluster_vpc = "projects/anyscale-project/global/networks/anyscale-network"
    ```
  EOT
  type        = string
}

variable "anyscale_project_id" {
  description = <<-EOT
    (Required) The ID of the project to create the resource in. If not provided, the provider project is used.

    ex:
    ```
    anyscale_project_id = "my-project-id-142323"
    ```
  EOT
  type        = string
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------
variable "anyscale_cloud_id" {
  description = <<-EOT
    (Optional) Anyscale Cloud ID

    ex:
    ```
    anyscale_cloud_id = "cld_1234567890"
    ```
  EOT
  type        = string
  default     = null
  validation {
    condition = (
      var.anyscale_cloud_id == null ? true : (
        length(var.anyscale_cloud_id) > 4 &&
        substr(var.anyscale_cloud_id, 0, 4) == "cld_"
      )
    )
    error_message = "The anyscale_cloud_id value must start with \"cld_\"."
  }
}

variable "module_enabled" {
  description = <<-EOT
    (Optional) Determines whether to create the resources inside this module.

    ex:
    ```
    module_enabled = true
    ```
  EOT
  type        = bool
  default     = false
}

variable "google_region" {
  description = <<-EOT
    (Optional) The Google region in which all resources will be created. If not provided, the provider region is used.

    ex:
    ```
    google_region = "us-central1"
    ```
  EOT
  type        = string
  default     = null
}
variable "google_zone" {
  description = <<-EOT
    (Optional) The Google zone in which all resources will be created. If not provided, the provider zone is used.

    ex:
    ```
    google_zone = "us-central1"
    ```
  EOT
  type        = string
  default     = null
}

variable "labels" {
  description = <<-EOT
    (Optional) A map of labels to add to all resources that accept labels.

    ex:
    ```
    labels = {
      "test" : true,
      "env"  : "test"
    }
    ```
  EOT
  type        = map(string)
  default     = {}
}

variable "enable_random_name_suffix" {
  description = <<-EOT
    (Optional) Determines if a suffix of random characters will be added to the Anyscale resources.

    ex:
    ```
    enable_random_name_suffix = true
    ```
  EOT
  type        = bool
  default     = true
}
variable "random_char_length" {
  description = <<-EOT
    (Optional) Sets the length of random characters to be appended as a suffix.
    Depends on `enable_random_name_suffix` being set to `true`.
    Must be an even number, and must be at least 4.

    ex:
    ```
    random_char_length = 4
    ```
  EOT
  type        = number
  default     = 4
  validation {
    condition     = var.random_char_length % 2 == 0 || var.random_char_length < 4
    error_message = "`random_char_length` must be an even number and greater than or equal to 4."
  }
}

variable "deletion_protection" {
  description = <<-EOT
    (Optional) Determines whether or not to allow Terraform to destroy the cluster.

    If set to `true`, the cluster cannot be deleted.

    ex:
    ```
    deletion_protection = true
    ```
  EOT
  type        = bool
  default     = true
}

variable "timeouts" {
  description = <<-EOT
    (Optional) Timeout for cluster operations.

    ex:
    ```
    timeouts = {
      create = "30m"
      update = "30m"
      delete = "30m"
    }
    ```
  EOT
  type        = map(string)
  default     = {}
  validation {
    condition     = !contains([for t in keys(var.timeouts) : contains(["create", "update", "delete"], t)], false)
    error_message = "Only create, update, delete timeouts can be specified."
  }
}

variable "gke_cluster_type" {
  description = <<-EOT
    (Optional) The type of the GKE cluster to create.

    Accepted values are `standard` and `autopilot`.

    ex:
    ```
    gke_cluster_type = "standard"
    ```
  EOT
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "autopilot"], var.gke_cluster_type)
    error_message = "The gke_cluster_type must be one of standard or autopilot."
  }
}

variable "gke_cluster_name" {
  description = <<-EOT
    (Optional) The name of the Anyscale GKE cluster to create.
    Conflicts with `anyscale_gke_cluster_name_prefix`.
    Must be unique within a project.

    ex:
    ```
    gke_cluster_name = "anyscale-gke-cluster"
    ```
  EOT
  type        = string
  default     = null
}

variable "gke_cluster_name_prefix" {
  description = <<-EOT
    (Optional) The prefix of the Anyscale GKE cluster to create.
    Conflicts `with anyscale_gke_cluster_name`.

    Because it is the prefix, it can end in a hyphen as it will have a random suffix appended to it.

    ex:
    ```
    anyscale_gke_cluster_name_prefix = "anyscale-gke-cluster-"
    ```
  EOT
  type        = string
  default     = "anyscale-gke-cluster-"
}

variable "gke_cluster_description" {
  description = <<-EOT
    (Optional) The description of the Anyscale GKE cluster to create.

    ex:
    ```
    gke_cluster_description = "Anyscale GKE Cluster"
    ```
  EOT
  type        = string
  default     = "Anyscale GKE Cluster"
}

# -----------------------------------------
# Kubernetes networking related parameters
# -----------------------------------------

variable "regional_cluster" {
  description = <<-EOT
    (Optional) Determines if the Anyscale GKE cluster is regional or zonal.

    If set to `true`, the cluster will be regional.
    If set to `false`, the cluster will be zonal.

    ex:
    ```
    regional_cluster = true
    ```
  EOT
  type        = bool
  default     = true
}

variable "gke_region" {
  description = <<-EOT
    (Optional) The region of the Anyscale GKE cluster to create.

    Must be provided if `regional_cluster` is set to `true`.

    ex:
    ```
    gke_location = "us-central1"
    ```
  EOT
  type        = string
  default     = null
}

variable "gke_zones" {
  description = <<-EOT
    (Optional) The zones to host the Anyscale GKE cluster in.

    Must be provided if `regional_cluster` is set to `false`.
    Optional if `regional_cluster` is set to `true`.

    ex:
    ```
    gke_zones = ["us-central1-a", "us-central1-b"]
    ```
  EOT
  type        = list(string)
  default     = []
}

variable "gke_cluster_subnet" {
  description = <<-EOT
    (Optional) The name of the subnet to which the filestore is attached.

    ex:
    ```
    gke_cluster_subnet = "projects/anyscale-project/regions/us-central1/subnetworks/anyscale-subnet"
    ```
  EOT
  type        = string
  default     = null
}

variable "gke_cluster_ipv4_cidr" {
  description = <<-EOT
    (Optional) The IP range for the Anyscale GKE cluster.

    One of `gke_cluster_ipv4_cidr` or `ip_range_name_pods` must be set.

    ex:
    ```
    gke_cluster_ipv4_cidr = "10.0.2.0/24"
    ```
  EOT
  type        = string
  default     = null
}

variable "gke_services_range_cidr" {
  description = <<-EOT
    (Required) The IP range for the services in the Anyscale GKE cluster.

    One of `gke_services_range_cidr` or `ip_range_name_services` must be set.

    ex:
    ```
    gke_services_range_cidr = "10.0.1.0/24"
    ```
  EOT
  type        = string
  default     = null
}

variable "ip_range_name_pods" {
  description = <<-EOT
    (Optional) The name of the secondary range for the pods in the Anyscale GKE cluster.

    One of `ip_range_name_pods` or `gke_cluster_ipv4_cidr` must be set.

    ex:
    ```
    ip_range_name_pods = "anyscale-pods"
    ```
  EOT
  type        = string
  default     = null
}

variable "ip_range_name_services" {
  description = <<-EOT
    (Optional) The name of the secondary range for the services in the Anyscale GKE cluster.

    One of `ip_range_name_services` or `gke_services_range_cidr` must be set.

    ex:
    ```
    ip_range_name_services = "anyscale-services"
    ```
  EOT
  type        = string
  default     = null
}

variable "additional_ip_range_names_pods" {
  description = <<-EOT
    List of _names_ of the additional secondary subnet ip ranges to use for pods
    in the Anyscale GKE cluster.

    ex:
    ```
    additional_ip_range_names_pods = ["anyscale-pods-2", "anyscale-pods-3"]
    ```
  EOT
  type        = list(string)
  default     = []
}

variable "gke_network_policy" {
  description = <<-EOT
    (Optional) The network policy for the Anyscale GKE cluster.

    ex:
    ```
    gke_network_policy = {
      enabled  = true
      provider = "CALICO"
    }
    ```
  EOT
  type = object({
    enabled  = bool
    provider = string
  })
  default = null
}

variable "enable_private_nodes" {
  description = <<-EOT
    (Optional) Determines if the Anyscale GKE nodes are private.

    If set to `true`, the cluster will be private.

    ex:
    ```
    enable_private_nodes = true
    ```
  EOT
  type        = bool
  default     = false
}

variable "enable_private_endpoint" {
  description = <<-EOT
    (Optional) Determines if the Anyscale GKE cluster has a private endpoint.

    If set to `true`, the cluster will have a private endpoint.

    ex:
    ```
    enable_private_endpoint = true
    ```
  EOT
  type        = bool
  default     = false
}

variable "master_authorized_networks" {
  description = <<-EOT
    (Optional) List of master authorized networks.

    If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists).

    ex:
    ```
    master_authorized_networks = [
      {
        cidr_block   = "32.0.0.1/32"
        display_name = "my-authorized-network"
      }
    ]
    ```
  EOT

  type    = list(object({ cidr_block = string, display_name = string }))
  default = []
}

# -----------------------------
# Kubernetes Engine Parameters
# -----------------------------
variable "kubernetes_version" {
  description = <<-EOT
    (Optional) The Kubernetes version.

    If set to 'latest' it will pull latest available version in the selected region.

    ex:
    ```
    kubernetes_version = "1.20.8-gke.900"
    ```
  EOT
  type        = string
  default     = "latest"
}

variable "kubernetes_release_channel" {
  description = <<-EOT
    (Optional) The release channel of this cluster.

    Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`."

    ex:
    ```
    kubernetes_release_channel = "REGULAR"
    ```
  EOT
  type        = string
  default     = "REGULAR"
  validation {
    condition     = contains(["UNSPECIFIED", "RAPID", "REGULAR", "STABLE"], var.kubernetes_release_channel)
    error_message = "The kubernetes_release_channel must be one of UNSPECIFIED, RAPID, REGULAR, or STABLE."
  }
}

# -----------------------------
# Kubernetes Maintenance
# -----------------------------
variable "maintenance_start_time" {
  description = <<-EOT
    (Optional) Time window specified for recurring maintenance operations in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339) format.

    ex:
    ```
    maintenance_start_time = "05:00"
    ```
  EOT
  type        = string
  default     = "03:00"
}

variable "maintenance_end_time" {
  description = <<-EOT
    (Optional) Time window specified for recurring maintenance operations in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339) format.

    ex:
    ```
    maintenance_end_time = "2021-01-01T06:00:00Z"
    ```
  EOT
  type        = string
  default     = null
}

variable "maintenance_exclusions" {
  description = <<-EOT
    (Optional) List of maintenance exclusions.

    A cluster can have up to three.

    ex:
    ```
    maintenance_exclusions = [
      {
        name            = "maintenance-exclusion"
        start_time      = "2021-01-01T05:00:00Z"
        end_time        = "2021-01-01T06:00:00Z"
        exclusion_scope = "ZONE"
      }
    ]
    ```
  EOT
  type = list(
    object(
      {
        name            = string,
        start_time      = string,
        end_time        = string,
        exclusion_scope = string
      }
    )
  )
  default = []
}

variable "maintenance_recurrence" {
  description = <<-EOT
    (Optional) Recurrence rule for the maintenance window in [RFC5545](https://datatracker.ietf.org/doc/html/rfc5545) format.

    If provided, `maintenance_start_time` and `maintenance_end_time` must also be provided.

    ex:
    ```
    maintenance_recurrence = "FREQ=WEEKLY;BYDAY=MO"
    ```
  EOT
  type        = string
  default     = null
}

# -----------------------------
# Kubernetes auth parameters
# -----------------------------
variable "enable_binary_authorization" {
  description = <<-EOT
    (Optional) Determines if binary authorization is enabled for the Anyscale GKE cluster.

    ex:
    ```
    enable_binary_authorization = true
    ```
  EOT
  type        = bool
  default     = false
}

variable "enable_client_certificate" {
  description = <<-EOT
    (Optional) Determines if client certificate is enabled for the Anyscale GKE cluster.

    Warning: Changing this is a destructive operation that will force your cluster to be recreated.

    ex:
    ```
    enable_client_certificate = true
    ```
  EOT
  type        = bool
  default     = false
}

# -----------------------------
# Standard GKE Cluster Autoscaling Config
# -----------------------------
variable "enable_gke_autoscaling" {
  description = <<-EOT
    (Optional) Determines if autoscaling is enabled for the Anyscale GKE cluster.

    ex:
    ```
    enable_gke_autoscaling = true
    ```
  EOT
  type        = bool
  default     = true
}

variable "gke_autoscaling_profile" {
  description = <<-EOT
    (Optional) The autoscaling profile for the Anyscale GKE cluster.

    Accepted values are `BALANCED`, `OPTIMISTIC`, and `CONSERVATIVE`.

    ex:
    ```
    gke_autoscaling_profile = "BALANCED"
    ```
  EOT
  type        = string
  default     = "BALANCED"
  validation {
    condition     = contains(["BALANCED", "OPTIMISTIC", "CONSERVATIVE"], var.gke_autoscaling_profile)
    error_message = "The gke_autoscaling_profile must be one of `BALANCED`, `OPTIMISTIC`, or `CONSERVATIVE`."
  }
}

variable "gke_cluster_gcp_iam_service_account" {
  description = <<-EOT
    (Optional) The GCP Service Account that will be used by the GKE Cluster when configured with Autoscaling enabled.

    ex:
    ```
    gke_cluster_gcp_iam_service_account = "anyscale-cluster@anyscale-example-gke.iam.gserviceaccount.com
    ```
  EOT
  type        = string
  default     = null
}

variable "gke_cluster_default_disk_config" {
  description = <<-EOT
    (Optional) The default disk configuration for the Anyscale GKE cluster.

    ex:
    ```
    gke_cluster_default_disk_config = {
      disk_type = "pd-balanced"
      disk_size = 100
    }
    ```
  EOT
  type = object({
    disk_type = string
    disk_size = number
  })
  default = {
    disk_type = "pd-balanced"
    disk_size = 500
  }
  validation {
    condition     = contains(["pd-standard", "pd-balanced", "pd-ssd"], var.gke_cluster_default_disk_config.disk_type)
    error_message = "The disk type must be one of `pd-standard`, `pd-balanced`, or `pd-ssd`."
  }
}

variable "gke_node_image_type" {
  description = <<-EOT
    (Optional) The image type for the Anyscale GKE cluster.

    Accepted values are `COS`, `COS_CONTAINERD`, and `UBUNTU`.

    ex:
    ```
    gke_node_image_type = "COS"
    ```
  EOT
  type        = string
  default     = "COS_CONTAINERD"
  validation {
    condition     = contains(["COS", "COS_CONTAINERD", "UBUNTU"], var.gke_node_image_type)
    error_message = "The gke_node_image_type must be one of COS, COS_CONTAINERD, or UBUNTU."
  }
}

variable "gke_autoscaling_node_management" {
  description = <<-EOT
    (Optional) The management configuration for the Anyscale GKE cluster.

    ex:
    ```
    gke_autoscaling_node_management = {
      auto_repair  = true
      auto_upgrade = true
    }
    ```
  EOT
  type = object({
    auto_repair  = bool
    auto_upgrade = bool
  })
  default = {
    auto_repair  = true
    auto_upgrade = true
  }
}

variable "gke_autoscaling_upgrade_settings" {
  description = <<-EOT
    (Optional) The upgrade settings for the Anyscale GKE cluster.

    ex:
    ```
    gke_autoscaling_upgrade_settings = {
      max_surge       = 1
      max_unavailable = 0
      strategy        = "SURGE"
    }
    ```
  EOT
  type = object({
    max_surge       = number
    max_unavailable = number
    strategy        = string
  })
  default = {
    max_surge       = 1
    max_unavailable = 0
    strategy        = "SURGE"
  }
  validation {
    condition     = contains(["SURGE", "REPLACE"], var.gke_autoscaling_upgrade_settings.strategy)
    error_message = "The upgrade strategy must be one of SURGE or REPLACE."
  }
}

variable "gke_autscaling_resource_limits" {
  description = <<-EOT
    (Optional) The resource limits for the Anyscale GKE cluster.

    ex:
    ```
    gke_autscaling_resource_limits = {
      memory = {
        minimum = 0
        maximum = 1000000000
      }
      cpu = {
        minimum = 0
        maximum = 1000000000
      }
    }
    ```
  EOT
  type = object({
    memory = object({ minimum = number, maximum = number })
    cpu    = object({ minimum = number, maximum = number })
  })
  default = {
    memory = {
      minimum = 0
      maximum = 1000000000
    }
    cpu = {
      minimum = 0
      maximum = 1000000000
    }
  }
}

# -----------------------------
# Additional Kubernetes/GKE params
# -----------------------------
variable "remove_default_node_pool" {
  description = <<-EOT
    (Optional) Determines if the default node pool will be removed from the Anyscale GKE cluster.

    ex:
    ```
    remove_default_node_pool = true
    ```
  EOT
  type        = bool
  default     = true
}
variable "default_node_pool_initial_node_count" {
  description = <<-EOT
    (Optional) The number of nodes to create in this cluster's default node pool.

    ex:
    ```
    default_node_pool_initial_node_count = 3
    ```
  EOT
  type        = number
  default     = 1
}

variable "enable_tpu" {
  description = <<-EOT
    (Optional) Determines if a TPU will be enabled with the Anyscale GKE cluster.

    ex:
    ```
    enable_tpu = true
    ```
  EOT
  type        = bool
  default     = false
}
