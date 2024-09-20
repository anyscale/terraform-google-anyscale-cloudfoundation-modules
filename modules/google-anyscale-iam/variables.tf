# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ------------------------------------------------------------------------------
variable "anyscale_org_id" {
  description = "(Required) Anyscale Organization ID"
  type        = string
  validation {
    condition = (
      length(var.anyscale_org_id) > 4 &&
      substr(var.anyscale_org_id, 0, 4) == "org_"
    )
    error_message = "The anyscale_org_id value must start with \"org_\"."
  }
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------
variable "anyscale_cloud_id" {
  description = "(Optional) Anyscale Cloud ID"
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
  description = "(Optional) Determines whether to create the resources inside this module. Default is `true`."
  type        = bool
  default     = true
}

variable "anyscale_project_id" {
  description = "(Optional) The ID of the project to create the resource in. If not provided, the provider project is used. Default is `null`."
  type        = string
  default     = null
}
variable "google_region" {
  description = "(Optional) The Google region in which all resources will be created. If it is not provided, the provider region is used. Default is `null`."
  type        = string
  default     = null
}

variable "enable_random_name_suffix" {
  description = <<-EOF
    (Optional) Determines if a suffix of random characters will be added to the Anyscale resources.
    Default is `true`
  EOF
  type        = bool
  default     = true
}
variable "random_char_length" {
  description = <<-EOT
    (Optional) Sets the length of random characters to be appended as a suffix.
    Depends on `random_bucket_suffix` being set to `true`.
    Must be an even number, and must be at least 4.
    Default is `4`.
  EOT
  type        = number
  default     = 4
  validation {
    condition     = var.random_char_length % 2 == 0 || var.random_char_length < 4
    error_message = "`random_char_length` must be an even number and greater than or equal to 4."
  }
}
# --------------------------------------------------------------
# Anyscale Cross Acct Access Service Account
# --------------------------------------------------------------
variable "create_anyscale_access_service_acct" {
  description = "(Optional) Determines whether to create the Anyscale access service account. Default is `true`."
  type        = bool
  default     = true
}

variable "anyscale_access_service_acct_name" {
  description = <<-EOT
    (Optional, forces creation of new resource)
    The name of the Anyscale IAM access service account.

    Overrides `anyscale_access_service_acct_name_prefix`.

    ex:
    ```
    anyscale_access_service_acct_name = "anyscale-access-service-acct"
    ```
  EOT
  type        = string
  default     = null
  validation {
    condition = var.anyscale_access_service_acct_name == null ? true : (
      can(regex("^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$", var.anyscale_access_service_acct_name))
    )
    error_message = "`anyscale_access_service_acct_name` must match regex: ^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$."
  }
}

variable "anyscale_access_service_acct_name_prefix" {
  description = <<-EOT
    (Optional, forces creation of new resource)
    The prefix of the Anyscale IAM access service account.

    Conflicts with anyscale_access_service_acct_name.

    ex:
    ```
    anyscale_access_service_acct_name_prefix = "anyscale-access-"
    ```
  EOT
  type        = string
  default     = "anyscale-crossacct-"
  validation {
    condition = var.anyscale_access_service_acct_name_prefix == null ? true : (
      can(regex("^[a-z](?:[-a-z0-9]{4,24})$", var.anyscale_access_service_acct_name_prefix))
    )
    error_message = "`anyscale_access_service_acct_name_prefix` must match regex: ^[a-z](?:[-a-z0-9]{4,24})$."
  }
}

variable "anyscale_access_service_acct_description" {
  description = <<-EOT
    (Optional) Anyscale IAM access service account description.

    If this is `null` the description will be set to \"Anyscale access service account\" in a local variable.

    ex:
    ```
    anyscale_access_service_acct_description = "Anyscale access service account"
    ```
  EOT
  type        = string
  default     = null
}

# variable "anyscale_access_service_acct_project_permissions" {
#   description = <<-EOT
#     (Optional) A list of permission roles

#     These permission roles will be granted to the service account at the project level.

#     ex:
#     ```
#     anyscale_access_service_acct_project_permissions = ["roles/owner"]
#     ```
#   EOT
#   type        = list(string)
#   default     = ["roles/owner"]
# }

variable "anyscale_access_service_acct_binding_permissions" {
  description = <<-EOT
    (Optional) A list of permission roles to grant to the Anyscale IAM access service account at the Service Account level.
    Default is `["roles/iam.serviceAccountTokenCreator"]`.
  EOT
  type        = list(string)
  default     = ["roles/iam.serviceAccountTokenCreator"]
}

# - Role for Anyscale Cross Account Access
variable "create_anyscale_access_role" {
  description = <<-EOT
    (Optional) Determines whether to create the Anyscale access role.

    ex:
    ```
    create_anyscale_access_role = true
    ```
  EOT
  type        = bool
  default     = true
}

variable "existing_anyscale_access_role_name" {
  description = <<-EOT
    (Optional) The name of an existing Anyscale IAM access role to use.

    If provided, will skip creating the Anyscale access role.

    ex:
    ```
    existing_anyscale_access_role_name = "projects/1234567890/roles/anyscale_access_role"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_access_role_id" {
  description = <<-EOT
    (Optional, forces creation of new resource) The ID of the Anyscale IAM access role.

    Overrides `anyscale_access_role_id_prefix`.

    ex:
    ```
    anyscale_access_role_id = "anyscale_access_role"
    ```
  EOT
  type        = string
  default     = null
  validation {
    condition = var.anyscale_access_role_id == null ? true : (
      can(regex("^[a-zA-Z0-9_]{4,28}$", var.anyscale_access_role_id))
    )
    error_message = "`anyscale_access_role_name` must match regex: ^[a-zA-Z0-9_]{4,28}$."
  }
}

variable "anyscale_access_role_id_prefix" {
  description = <<-EOT
    (Optional, forces creation of new resource) The prefix of the Anyscale IAM access role.

    If `anyscale_access_role_id` is provided, it will override this variable.
    If set to `null`, the prefix will be set to \"anyscale_\" in a local variable.

    ex:
    ```
    anyscale_access_role_id_prefix = "anyscale_crossacct_role_"
    ```
  EOT
  type        = string
  default     = "anyscale_crossacct_role_"
  validation {
    condition = var.anyscale_access_role_id_prefix == null ? true : (
      can(regex("^[a-zA-Z0-9_]{4,24}$", var.anyscale_access_role_id_prefix))
    )
    error_message = "`anyscale_access_role_id_prefix` must match regex: ^[a-zA-Z0-9_]{4,24}$."
  }
}

variable "anyscale_access_role_description" {
  description = <<-EOT
    (Optional) Anyscale IAM access role description.

    ex:
    ```
    anyscale_access_role_description = "Anyscale access role"
    ```
  EOT
  type        = string
  default     = "Anyscale access role"
}

# - Workload Identity Pool for Anyscale Cross Account Access
variable "existing_workload_identity_provider_name" {
  description = <<-EOF
    (Optional) The name of an existing workload identity provider to use.

    If provided, will skip creating the workload identity pool and provider.

    You can retrieve the name of an existing Workload Identity Provider by running the following command:
    ```
    gcloud iam workload-identity-pools providers list --location global --workload-identity-pool anyscale-access-pool
    ```

    ex:
    ```
    existing_workload_identity_provider_name = "projects/1234567890/locations/global/workloadIdentityPools/anyscale-access-pool/providers/anyscale-access-provider"
    ```
    ```
  EOF
  type        = string
  default     = null
}
variable "workload_identity_pool_name" {
  description = "(Optional) The name of the workload identity pool. If it is not provided, the Anyscale Access service account name is used. Default is `null`."
  type        = string
  default     = null
}
variable "workload_identity_pool_display_name" {
  description = "(Optional) The display name of the workload identity pool. Must be less than or equal to 32 chars. Default is `Anyscale Cross Account AWS Access`."
  type        = string
  default     = "Anyscale Cross Account Access"
}
variable "workload_identity_pool_description" {
  description = "(Optional) The description of the workload identity pool. Default is `Used to provide Anyscale access from AWS.`."
  type        = string
  default     = "Used to provide Anyscale access from AWS."
}

variable "workload_identity_pool_provider_name" {
  description = "(Optional) The name of the workload identity pool provider. If it is not provided, the Anyscale Access service account name is used. Default is `null`."
  type        = string
  default     = null
}
variable "anyscale_access_aws_account_id" {
  description = "(Optional) The AWS account ID to grant access to. This will be overridden by `workload_anyscale_aws_account_id`. Default is `525325868955`."
  type        = string
  default     = "525325868955"
}
variable "workload_anyscale_aws_account_id" {
  description = "(Optional) The AWS account ID to grant access to. This will override the `anyscale_access_aws_account_id` which is the default account ID to use. Default is `null`."
  type        = string
  default     = null
}

# --------------------------------------------------------------
# Anyscale Access Service Account Access Role
# --------------------------------------------------------------

# --------------------------------------------------------------
# Anyscale Cluster Node Service Account
# --------------------------------------------------------------
variable "create_anyscale_cluster_node_service_acct" {
  description = <<-EOT
    (Optional) Determines whether to create the Anyscale cluster service account.

    ex:
    ```
    create_anyscale_cluster_node_service_acct = true
    ```
  EOT
  type        = bool
  default     = true
}

variable "anyscale_cluster_node_service_acct_name" {
  description = <<-EOT
    (Optional, forces creation of new resource) The name of the Anyscale IAM cluster node service account.

    Overrides `anyscale_cluster_node_service_acct_name_prefix`.

    ex:
    ```
    anyscale_cluster_node_service_acct_name = "anyscale-cluster-acct"
    ```
  EOT
  type        = string
  default     = null
  validation {
    condition = var.anyscale_cluster_node_service_acct_name == null ? true : (
      can(regex("^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$", var.anyscale_cluster_node_service_acct_name))
    )
    error_message = "`anyscale_cluster_node_service_acct_name` must match regex: ^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$."
  }
}

variable "anyscale_cluster_node_service_acct_name_prefix" {
  description = <<-EOT
    (Optional, forces creation of new resource) The prefix of the Anyscale IAM cluster service account.

    If `anyscale_cluster_node_service_acct_name` is provided, it will override this variable.

    ex:
    ```
    anyscale_cluster_node_service_acct_name_prefix = "anyscale-cluster-"
    ```
  EOT
  type        = string
  default     = "anyscale-cluster-"
  validation {
    condition = var.anyscale_cluster_node_service_acct_name_prefix == null ? true : (
      can(regex("^[a-z](?:[-a-z0-9]{4,24})$", var.anyscale_cluster_node_service_acct_name_prefix))
    )
    error_message = "`anyscale_cluster_node_service_acct_name_prefix` must match regex: ^[a-z](?:[-a-z0-9]{4,24})$."
  }
}

variable "anyscale_cluster_node_service_acct_description" {
  description = <<-EOT
    (Optional) IAM cluster node service account description.

    If this is `null` the description will be set to `Anyscale cluster node service account` in a local variable.

    ex:
    ```
    anyscale_cluster_node_service_acct_description = "Anyscale cluster node service account for cloud"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_cluster_node_service_acct_permissions" {
  description = <<-EOT
    (Optional) A list of permission roles to grant to the Anyscale IAM cluster node service account.

    ex:
    ```
    anyscale_cluster_node_service_acct_permissions = ["roles/artifactregistry.reader"]
    ```
  EOT
  type        = list(string)
  default     = ["roles/artifactregistry.reader"]
}

variable "enable_anyscale_cluster_logging_monitoring" {
  description = <<-EOF
    (Optional) Determines whether to grant the Cluster Node access to the monitoring and logging.

    ex:
    ```
    enable_anyscale_cluster_logging_monitoring = true
    ```
  EOF
  type        = bool
  default     = false
}

# --------------------------------------------------------------
# GKE Cluster Service Account
# --------------------------------------------------------------
variable "create_gke_cluster_service_acct" {
  description = <<-EOT
    (Optional) Determines whether to create the GKE Cluster service account.

    ex:
    ```
    create_gke_cluster_service_acct = true
    ```
  EOT
  type        = bool
  default     = false
}

variable "gke_cluster_service_acct_description" {
  description = <<-EOT
    (Optional) GKE Cluster service account description.

    If this is `null` the description will be set to `Anyscale GKE cluster Service Account` in a local variable.

    ex:
    ```
    gke_cluster_sa_description = "Anyscale GKE cluster Service Account"
    ```
  EOT
  type        = string
  default     = null
}

variable "gke_cluster_service_acct_name" {
  description = <<-EOT
    (Optional, forces creation of new resource) The name of the GKE Cluster service account.

    Overrides `gke_cluster_service_acct_name_prefix`.

    ex:
    ```
    gke_cluster_service_acct_name = "gke-cluster-service-acct"
    ```
  EOT
  type        = string
  default     = null
  validation {
    condition = var.gke_cluster_service_acct_name == null ? true : (
      can(regex("^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$", var.gke_cluster_service_acct_name))
    )
    error_message = "`gke_cluster_service_acct_name` must match regex: ^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$."
  }
}

variable "gke_cluster_service_acct_name_prefix" {
  description = <<-EOT
    (Optional, forces creation of new resource) The prefix of the GKE Cluster service account.

    If `gke_cluster_service_acct_name` is provided, it will override this variable.

    ex:
    ```
    gke_cluster_service_acct_name_prefix = "gke-cluster-"
    ```
  EOT
  type        = string
  default     = "gke-cluster-"
  validation {
    condition = var.gke_cluster_service_acct_name_prefix == null ? true : (
      can(regex("^[a-z](?:[-a-z0-9]{4,24})$", var.gke_cluster_service_acct_name_prefix))
    )
    error_message = "`gke_cluster_service_acct_name_prefix` must match regex: ^[a-z](?:[-a-z0-9]{4,24})$."
  }
}

variable "gke_cluster_service_acct_permissions" {
  description = <<-EOT
    (Optional) A list of permission roles to grant to the GKE Cluster service account.

    ex:
    ```
    gke_cluster_service_acct_permissions = ["roles/container.defaultNodeServiceAccount"]
    ```
  EOT
  type        = list(string)
  default = [
    "roles/container.defaultNodeServiceAccount",
    "roles/monitoring.metricWriter",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/artifactregistry.reader"
  ]
}

variable "enable_gke_cluster_logging_monitoring" {
  description = <<-EOF
    (Optional) Determines whether to grant the GKE Cluster service account access to the monitoring and logging.

    ex:
    ```
    enable_gke_cluster_logging_monitoring = true
    ```
  EOF
  type        = bool
  default     = false
}
