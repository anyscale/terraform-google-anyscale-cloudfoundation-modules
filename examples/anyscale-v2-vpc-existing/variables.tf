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
variable "existing_project_id" {
  description = <<-EOT
    (Required) Google project ID to deploy Anyscale resources.

    ex:
    ```
    existing_project_id = "anyscale-project"
    ```
  EOT
  type        = string
}

variable "existing_vpc_name" {
  description = <<-EOT
    (Required) An existing VPC Name.

    If provided, this module will skip creating a new VPC with the Anyscale VPC module.
    An existing VPC Subnet Name (`existing_vpc_subnet_name`) is also required if this is provided.

    ex:
    ```
    existing_vpc_name = "anyscale-vpc"
    ```
  EOT
  type        = string
}


variable "existing_vpc_subnet_name" {
  description = <<-EOT
    (Required) Existing subnet name to create Anyscale resources in.

    If provided, this will skip creating resources with the Anyscale VPC module.
    An existing VPC Name (`existing_vpc_name`) is also required if this is provided.

    ex:
    ```
    existing_vpc_subnet_name = "anyscale-subnet"
    ```
  EOT
  type        = string
}

variable "existing_firewall_policy_name" {
  description = <<-EOT
    (Required) An existing firewall policy name.

    If provided, this will be used in the cloud registration output.
    This example expects an existing VPC and Firewall meeting [Anyscale Requirements](https://docs.anyscale.com/administration/cloud-deployment/deploy-gcp-cloud#3-choose-an-anyscale-cloud-deployment-method).

    ex:
    ```
    existing_firewall_policy_name = "anyscale-firewall-policy"
    ```
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
