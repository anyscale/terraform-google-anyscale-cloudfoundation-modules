# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ------------------------------------------------------------------------------
variable "billing_account_id" {
  description = "The ID of the billing account to associate this project with."
  type        = string
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------
variable "module_enabled" {
  description = "(Optional) Whether to create the resources inside this module. Default is `true`."
  type        = bool
  default     = true
}

variable "deletion_policy" {
  description = <<-EOT
    (Optional) The deletion policy for the project.

    This can be one of the following:
    - `DELETE` - The project will be shut down and scheduled for deletion.
    - `ABANDON` - The project will be marked for deletion, but will remain available for 30 days.
    - `PREVENT` - The project will be prevented from being deleted

    ex:
    ```
    deletion_policy = "ABANDON"
    ```
  EOT
  type        = string
  default     = "DELETE"
  validation {
    condition     = can(regex("^(DELETE|ABANDON|PREVENT)$", var.deletion_policy))
    error_message = "deletion_policy must be one of DELETE, ABANDON, or PREVENT."
  }
}

variable "anyscale_project_name" {
  description = "(Optional) Google Cloud Project name. Default is `null`."
  type        = string
  default     = null
}

variable "anyscale_project_name_prefix" {
  description = <<-EOT
    (Optional) Prefix to be used for the project name.
    Conflicts with `anyscale_project_name`. If `anyscale_project_name` is provided, it will be used and `anyscale_project_name_prefix` will be ignored.
    Default is `anyscale-project-`.
  EOT
  type        = string
  default     = "anyscale-project-"
}

variable "anyscale_project_id" {
  description = "(Optional) Google Cloud Project ID. If not provided, the `project_name_computed` local variable will be used."
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
  description = <<-EOF
    (Optional) Sets the length of random characters to be appended as a suffix.
    Depends on `random_bucket_suffix` being set to `true`.
    Must be an even number, and must be at least 4.
    Default is `4`.
  EOF
  type        = number
  default     = 4
  validation {
    condition     = var.random_char_length % 2 == 0 || var.random_char_length < 4
    error_message = "`random_char_length` must be an even number and greater than or equal to 4."
  }
}


variable "organization_id" {
  description = <<-EOF
    (Optional) Google Cloud Organization ID.
    Conflicts with `folder_id`. If `folder_id` is provided, it will be used and `organization_id` will be ignored.
    Changing this forces the project to be migrated to the newly specified organization.
    Default is `null`.
  EOF
  type        = string
  default     = null
}
variable "folder_id" {
  description = <<-EOF
    (Optional) The ID of a Google Cloud Folder.
    Conflicts with `organization_id`. If `folder_id` is provided, it will be used and `organization_id` will be ignored.
    Changing this forces the project to be migrated to the newly specified folder.
    Default is `null`.
  EOF
  type        = string
  default     = null
}

variable "labels" {
  description = "(Optional) A map of labels to add to all resources that accept labels."
  type        = map(string)
  default     = {}
}
