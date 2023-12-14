# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
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
# variable "google_region" {
#   description = "The Google region in which all resources will be created."
#   type        = string
# }

variable "google_project_id" {
  description = "ID of the Project to put these resources in"
  type        = string
}

variable "existing_workload_identity_provider_name" {
  description = <<-EOT
    (Optional) Existing Workload Identity Provider Name.

    The name of an existing Workload Identity Provider that you'd like to use. This can be in a different project.
    If provided, this will skip creating a new Workload Identity Provider with the Anyscale IAM module.

    ex:
    ```
    existing_workload_identity_provider_name = "projects/1234567890/locations/global/workloadIdentityPools/anyscale-existing-pool/providers/anyscale-existing-provider"
    ```
  EOT
  type        = string
  default     = null
}
