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
# Anyscale Cross Acct Access Role
# --------------------------------------------------------------
variable "create_anyscale_access_role" {
  description = "(Optional) Determines whether to create the Anyscale access role. Default is `true`."
  type        = bool
  default     = true
}

variable "anyscale_access_role_name" {
  description = "(Optional, forces creation of new resource) The name of the Anyscale IAM access role. Conflicts with anyscale_access_role_name_prefix. Default is `null`."
  type        = string
  default     = null
  validation {
    condition = var.anyscale_access_role_name == null ? true : (
      can(regex("^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$", var.anyscale_access_role_name))
    )
    error_message = "`anyscale_access_role_name` must match regex: ^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$."
  }
}

variable "anyscale_access_role_name_prefix" {
  description = "(Optional, forces creation of new resource) The prefix of the Anyscale IAM access role. Conflicts with anyscale_access_role_name. Default is `anyscale-iam-role-`."
  type        = string
  default     = "anyscale-crossacct-role-"
  validation {
    condition = var.anyscale_access_role_name_prefix == null ? true : (
      can(regex("^[a-z](?:[-a-z0-9]{4,24})$", var.anyscale_access_role_name_prefix))
    )
    error_message = "`anyscale_access_role_name_prefix` must match regex: ^[a-z](?:[-a-z0-9]{4,24})$."
  }
}

variable "anyscale_access_role_description" {
  description = "(Optional) Anyscale IAM access role description. If this is `null` the description will be set to \"Anyscale access role\". Default is `null`."
  type        = string
  default     = null
}

variable "anyscale_access_role_project_permissions" {
  description = <<-EOF
    (Optional) A list of permission roles to grant to the Anyscale IAM access role at the project level.
    Default is `["roles/owner"]`.
  EOF
  type        = list(string)
  default     = ["roles/owner"]
}

variable "anyscale_access_role_binding_permissions" {
  description = <<-EOF
    (Optional) A list of permission roles to grant to the Anyscale IAM access role at the Service Account level.
    Default is `["roles/iam.serviceAccountTokenCreator"]`.
  EOF
  type        = list(string)
  default     = ["roles/iam.serviceAccountTokenCreator"]
}

variable "workload_identity_pool_name" {
  description = "(Optional) The name of the workload identity pool. If it is not provided, the Anyscale Access role name is used. Default is `null`."
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
  description = "(Optional) The name of the workload identity pool provider. If it is not provided, the Anyscale Access role name is used. Default is `null`."
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
# Anyscale Cluster Node Role
# --------------------------------------------------------------
variable "create_anyscale_cluster_node_role" {
  description = "(Optional) Determines whether to create the Anyscale cluster role. Default is `true`."
  type        = bool
  default     = true
}

variable "anyscale_cluster_node_role_name" {
  description = "(Optional, forces creation of new resource) The name of the Anyscale IAM cluster node role. Conflicts with anyscale_cluster_node_role_name_prefix. Default is `null`."
  type        = string
  default     = null
  validation {
    condition = var.anyscale_cluster_node_role_name == null ? true : (
      can(regex("^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$", var.anyscale_cluster_node_role_name))
    )
    error_message = "`anyscale_cluster_node_role_name` must match regex: ^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$."
  }
}

variable "anyscale_cluster_node_role_name_prefix" {
  description = "(Optional, forces creation of new resource) The prefix of the Anyscale IAM access role. Conflicts with anyscale_cluster_role_node_name. Default is `anyscale-cluster-`."
  type        = string
  default     = "anyscale-cluster-"
  validation {
    condition = var.anyscale_cluster_node_role_name_prefix == null ? true : (
      can(regex("^[a-z](?:[-a-z0-9]{4,24})$", var.anyscale_cluster_node_role_name_prefix))
    )
    error_message = "`anyscale_cluster_node_role_name_prefix` must match regex: ^[a-z](?:[-a-z0-9]{4,24})$."
  }
}

variable "anyscale_cluster_node_role_description" {
  description = "(Optional) IAM cluster node role description. If this is `null` the description will be set to \"Anyscale cluster node role\". Default is `null`."
  type        = string
  default     = null
}

variable "anyscale_cluster_node_role_permissions" {
  description = <<-EOF
    (Optional) A list of permission roles to grant to the Anyscale IAM cluster node role.
    Default is `["roles/artifactregistry.reader"]`.
  EOF
  type        = list(string)
  default     = ["roles/artifactregistry.reader"]
}
