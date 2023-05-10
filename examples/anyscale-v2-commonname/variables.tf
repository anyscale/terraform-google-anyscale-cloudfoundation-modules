# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "anyscale_google_region" {
  description = "(Required) Google region to deploy Anyscale resources."
  type        = string
}
variable "anyscale_google_zone" {
  description = "(Required) Google zone to deploy Anyscale resources."
  type        = string
}

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

# Project Related Required Variables
variable "root_folder_number" {
  description = "(Required) Google Folder number to deploy Anyscale resources. Will create a new sub-project by default."
  type        = string
}
variable "billing_account_id" {
  description = "(Required) Google billing account ID to deploy Anyscale resources."
  type        = string
}

variable "customer_ingress_cidr_ranges" {
  description = <<-EOT
    The IPv4 CIDR blocks that allows access Anyscale clusters.
    These are added to the firewall and allows port 443 (https) and 22 (ssh) access.
    ex: `52.1.1.23/32,10.1.0.0/16'
  EOT
  type        = string
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------
variable "anyscale_deploy_env" {
  description = "(Required) Anyscale deploy environment. Used in resource names and tags."
  type        = string
  validation {
    condition = (
      var.anyscale_deploy_env == "production" || var.anyscale_deploy_env == "development" || var.anyscale_deploy_env == "test"
    )
    error_message = "The anyscale_deploy_env only allows `production`, `test`, or `development`"
  }
  default = "production"
}

variable "anyscale_cloud_id" {
  description = "(Optional) Anyscale Cloud ID. Default is `null`."
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
