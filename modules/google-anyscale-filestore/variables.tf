# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ------------------------------------------------------------------------------
variable "filestore_vpc_name" {
  description = "(Required) The name of the VPC to which the filestore is attached."
  type        = string
}

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
variable "google_region" {
  description = "(Optional) The Google region in which all resources will be created. If not provided, the provider region is used. Default is `null`."
  type        = string
  default     = null
}
variable "google_zone" {
  description = "(Optional) The Google zone in which all resources will be created. If not provided, the provider zone is used. Default is `null`."
  type        = string
  default     = null
}

variable "labels" {
  description = "(Optional) A map of labels to add to all resources that accept labels."
  type        = map(string)
  default     = {}
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

variable "anyscale_filestore_name" {
  description = <<-EOT
    (Optional) The name of the filestore to create.
    Conflicts with `anyscale_filestore_name_prefix`.
    Must start with a lowercase letter followed by up to 62 lowercase letters, numbers, or hyphens, and cannot end with a hyphen.
    Default is `null`.
  EOT
  type        = string
  default     = null
  validation {
    condition = var.anyscale_filestore_name == null ? true : (
      can(regex("^(?:[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?)$", var.anyscale_filestore_name))
    )
    error_message = "`anyscale_filestore_name` must start with a lowercase letter followed by up to 62 lowercase letters, numbers, or hyphens, and cannot end with a hyphen."
  }
}

variable "anyscale_filestore_name_prefix" {
  description = <<-EOT
    (Optional) The prefix of the filestore to create.
    Conflicts `with anyscale_filestore_name`.
    Must start with a lowercase letter followed by up to 48 lowercase letters, numbers, or hyphens.
    Because it is the prefix, it can end in a hyphen as it will have a random suffix appended to it.
    Default is `anyscale-filestore-`."
  EOT
  type        = string
  default     = "anyscale-filestore-"
  validation {
    condition     = can(regex("^(?:[a-z](?:[-a-z0-9]{0,47})?)$", var.anyscale_filestore_name_prefix))
    error_message = "`anyscale_filestore_name_prefix` must start with a lowercase letter followed by up to 48 lowercase letters, numbers, or hyphens."
  }
}

variable "filestore_description" {
  description = "(Optional) The description of the filestore to create. If anyscale_cloud_id is provided, \"for anyscale_cloud_id\" will be appended. Default is `Anyscale Filestore`."
  type        = string
  default     = "Anyscale Filestore"
}

variable "filestore_tier" {
  description = <<-EOT
    (Optional) The tier of the filestore to create. Default is `STANDARD`.

    Supported values include `STANDARD`, `PREMIUM`, `BASIC_HDD`, `BASIC_SSD`, `HIGH_SCALE_SSD`, `ENTERPRISE`, `ZONAL`, and `REGIONAL`.

    ex:
    ```
    filestore_tier = "STANDARD"
    ```
  EOT
  type        = string
  default     = "STANDARD"
  validation {
    condition     = contains(["STANDARD", "PREMIUM", "BASIC_HDD", "BASIC_SSD", "HIGH_SCALE_SSD", "ENTERPRISE", "ZONAL", "REGIONAL"], var.filestore_tier)
    error_message = "The `filestore_tier` must be one of `STANDARD`, `PREMIUM`, `BASIC_HDD`, `BASIC_SSD`, `HIGH_SCALE_SSD`, `ENTERPRISE`, `ZONAL`, or `REGIONAL`."
  }
}

variable "filestore_location" {
  description = <<-EOT
    (Optional) The name of the Google Region or Availability Zone in which the filestore resource will be created.
    For `ENTERPRISE` tier instances, this should be Region.
    For `STANDARD`, `BASIC_HDD`, `BASIC_SSD`, and `HIGH_SCALE_SSD` tier instances, this should be Zone.
    If it is not provided, `google_region`, `google_zone` or provider configuration is used.
    Default is `null`.
  EOT
  type        = string
  default     = null
}

variable "anyscale_filestore_fileshare_name" {
  description = <<-EOT
    (Optional) The name of the fileshare to create.
    Conflicts with `anyscale_filestore_fileshare_name_prefix`.
    Must start with a letter, followed by letters, numbers, or underscores, and cannot end with an underscore.
    Default is `null`.
  EOT
  type        = string
  default     = null
  validation {
    condition = var.anyscale_filestore_fileshare_name == null ? true : (
      can(regex("^[a-zA-Z](?:[a-zA-Z0-9_]{2,14}[a-zA-Z0-9])?$", var.anyscale_filestore_fileshare_name))
    )
    error_message = "`anyscale_filestore_fileshare_name` must start with a letter, followed by letters, numbers, or underscores, and cannot end with an underscore. It must also be a maximum of 16 characters long."
  }
}

variable "anyscale_filestore_fileshare_capacity_gb" {
  description = "(Optional) The capacity of the fileshare to create. This must be at least 1024 GiB for the standard tier, or 2560 GiB for the premium tier. Default is `2560`."
  type        = number
  default     = 2560
}

variable "filestore_network_modes" {
  description = "(Optional) The modes in which the filestore will be created. Default is `[\"MODE_IPV4\"]`."
  type        = list(string)
  default     = ["MODE_IPV4"]
  validation {
    condition = alltrue([
      for mode in var.filestore_network_modes : contains(["MODE_IPV4", "ADDRESS_MODE_UNSPECIFIED", "MODE_IPV6"], mode)
    ])
    error_message = "The `filestore_network_modes` must be a list that can only contain `MODE_IPV4`, `ADDRESS_MODE_UNSPECIFIED`, or `MODE_IPV6`."
  }
}

variable "filestore_network_conect_mode" {
  description = <<-EOT
    (Optional) The connect modes in which the filestore will be created.

    If using a shared VPC, this should be set to `PRIVATE_SERVICE_ACCESS`, otherwise it should be set to `DIRECT_PEERING`.

    ex:
    ```
    filestore_network_conect_mode = "DIRECT_PEERING"
    ```
  EOT
  type        = string
  default     = "DIRECT_PEERING"
  validation {
    condition     = contains(["DIRECT_PEERING", "PRIVATE_SERVICE_ACCESS"], var.filestore_network_conect_mode)
    error_message = "The `filestore_network_conect_mode` must be a list that can only contain `DIRECT_PEERING`, or `PRIVATE_SERVICE_ACCESS`."
  }
}
