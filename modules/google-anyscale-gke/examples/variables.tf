# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "google_region" {
  description = "The Google region in which all resources will be created."
  type        = string
}

variable "google_project_id" {
  description = "ID of the Project to put these resources in"
  type        = string
}

variable "anyscale_organization_id" {
  description = "(Required) Anyscale Organization ID"
  type        = string
  validation {
    condition = (
      length(var.anyscale_organization_id) > 4 &&
      substr(var.anyscale_organization_id, 0, 4) == "org_"
    )
    error_message = "The anyscale_organization_id value must start with \"org_\"."
  }
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------
variable "anyscale_deploy_env" {
  description = <<-EOT
  (Optional) Anyscale deploy environment. Used in resource names and tags.

  ex:
  ```
  anyscale_deploy_env = "production"
  ```
  EOT

  type    = string
  default = "test"
  validation {
    condition = (
      var.anyscale_deploy_env == "production" || var.anyscale_deploy_env == "development" || var.anyscale_deploy_env == "test"
    )
    error_message = "The anyscale_deploy_env only allows `production`, `test`, or `development`"
  }
}

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
variable "labels" {
  description = "(Optional) A map of labels to all resources that accept labels."
  type        = map(string)
  default = {
    "test" : true,
    "environment" : "test"
  }
}
