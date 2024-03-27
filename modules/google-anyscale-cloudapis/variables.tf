# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------
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
variable "anyscale_activate_required_apis" {
  description = <<-EOT
    (Optional) The list of apis to activate within the project.
    Default enables APIs for compute, filestore, and storage.
  EOT
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "file.googleapis.com",
    "storage-component.googleapis.com",
    "storage.googleapis.com",
    "certificatemanager.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "deploymentmanager.googleapis.com"
  ]
}

variable "anyscale_activate_optional_apis" {
  description = <<-EOT
    (Optional) Optional APIs to activate.

    A list of optional apis to activate within the project.

    ex:
    ```
    anyscale_activate_optional_apis = [
      "cloudkms.googleapis.com",
      "containerregistry.googleapis.com",
      "logging.googleapis.com",
      "monitoring.googleapis.com",
      "redis.googleapis.com",
    ]
    ```
  EOT
  type        = list(string)
  default     = []
}

variable "disable_services_on_destroy" {
  description = <<-EOT
    (Optional) Determines if project services will be disabled when the resources are destroyed.

    More information in the [terraform documentation](https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_on_destroy).

    Setting to `true` can cause errors if removing optional services that are required by other services.

    ex:
    ```
    disable_services_on_destroy = true
    ```
  EOT
  type        = bool
  default     = false
}

variable "disable_dependent_services" {
  description = <<-EOT
    (Optional) Determines if services that are enabled and which depend on this service should also be disabled when this service is destroyed.

    More information in the [terraform documentation](https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_dependent_services).

    Setting to `true` can cause errors if disabling optional services that are required by other services.

    ex:
    ```
    disable_dependent_services = true
    ```
  EOT
  type        = bool
  default     = false
}
