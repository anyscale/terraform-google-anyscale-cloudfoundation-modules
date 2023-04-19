# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------
variable "anyscale_cloud_id" {
  description = "(Required) Anyscale Cloud ID"
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

# variable "google_region" {
#   description = "(Optional) The Google region in which all resources will be created. If not provided, the provider region is used. Default is `null`."
#   type        = string
#   default     = null
# }

# ------------------------------------------------------------------------------
# API Module Parameters
# ------------------------------------------------------------------------------
variable "anyscale_activate_apis" {
  description = <<-EOT
    (Optional) The list of apis to activate within the project.
    Default enables APIs for compute, filestore, and storage.
  EOT
  type        = list(string)
  default = [
    # "logging.googleapis.com",
    "compute.googleapis.com",
    # "monitoring.googleapis.com",
    # "iam.googleapis.com",
    "sts.googleapis.com",
    "file.googleapis.com",
    "storage-component.googleapis.com",
    "storage.googleapis.com",
  ]
}

# variable "activate_api_identities" {
#   description = <<-EOT
#     (Optional)
#     The list of service identities (Google Managed service account for the API) to force-create for the project (e.g. in order to grant additional roles).
#     APIs in this list will automatically be appended to `anyscale_activate_apis`.
#     Not including the API in this list will follow the default behaviour for identity creation (which is usually when the first resource using the API is created).
#     Any roles (e.g. service agent role) must be explicitly listed. See https://cloud.google.com/iam/docs/understanding-roles#service-agent-roles-roles for a list of related roles.
#     Default is an empty list.
#   EOT
#   type = list(object({
#     api   = string
#     roles = list(string)
#   }))
#   default = []
# }

variable "disable_services_on_destroy" {
  description = <<-EOT
    (Optional) Determines if project services will be disabled when the resources are destroyed.
    More information in the [terraform documentation](https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_on_destroy).
    Default is `true`.
  EOT
  type        = bool
  default     = true
}

variable "disable_dependent_services" {
  description = <<-EOT
    (Optional) Determines if services that are enabled and which depend on this service should also be disabled when this service is destroyed.
    More information in the [terraform documentation](https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_dependent_services).
  EOT
  default     = true
  type        = bool
}
