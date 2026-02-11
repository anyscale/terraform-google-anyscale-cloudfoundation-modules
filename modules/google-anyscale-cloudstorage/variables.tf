# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------
variable "module_enabled" {
  description = "(Optional) Whether to create the resources inside this module. Default is `true`."
  type        = bool
  default     = true
}

variable "anyscale_project_id" {
  description = "(Optional) The ID of the project to create the resource in. If not provided, the provider project is used. Default is `null`."
  type        = string
  default     = null
}

variable "labels" {
  description = "(Optional) A map of labels to all resources that accept labels. Default is an empty map."
  type        = map(string)
  default     = {}
}

variable "anyscale_bucket_name" {
  description = <<-EOT
    (Optional - forces new resource) The name of the bucket.
    Changing this forces creating a new bucket.
    This overrides the `anyscale_bucket_name_prefix` parameter.

    ex:
    ```
    anyscale_bucket_name = "my-bucket"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_bucket_name_prefix" {
  description = <<-EOT
    (Optional - forces new resource) Prefix for the bucket name.

    Creates a unique bucket name beginning with the specified prefix.
    Changing this forces creating a new bucket.
    If `anyscale_bucket_name` is provided, it overrides this parameter.

    ex:
    ```
    anyscale_bucket_name_prefix = "anyscale-"
    ```
  EOT
  type        = string
  default     = "anyscale-"
}

variable "enable_random_name_suffix" {
  description = <<-EOT
    (Optional) Determines if a suffix of random characters will be added to the `anyscale_bucket_prefix` or `anyscale_bucket_name`.

    ex:
    ```
    enable_random_name_suffix = true
    ```
  EOT
  type        = bool
  default     = true
}

variable "random_char_length" {
  description = <<-EOT
    (Optional) Sets the length of random characters to be appended as a suffix.
    Depends on `random_bucket_suffix` being set to `true`.
    Must be an even number, and must be at least 4.

    ex:
    ```
    random_char_length = 8
    ```
  EOT
  type        = number
  default     = 4
  validation {
    condition     = var.random_char_length % 2 == 0 || var.random_char_length < 4
    error_message = "`random_char_length` must be an even number and greater than or equal to 4."
  }
}

variable "bucket_location" {
  description = <<-EOT
    (Optional) A valid GCS location to create the bucket in.

    ex:
    ```
    bucket_location = "US"
    ```
  EOT
  type        = string
  default     = "US"
}

variable "bucket_storage_class" {
  description = <<-EOF
    (Optional) The bucket storage class.
    Must be one of: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE

    ex:
    ```
    bucket_storage_class = "STANDARD"
    ```
  EOF
  type        = string
  default     = "STANDARD"
  validation {
    condition = contains(
      [
        "STANDARD",
        "MULTI_REGIONAL",
        "REGIONAL",
        "NEARLINE",
        "COLDLINE",
        "ARCHIVE"
      ],
      var.bucket_storage_class
    )
    error_message = "`bucket_storage_class` must be one of: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
  }
}

variable "bucket_public_access_prevention" {
  description = <<-EOT
    (Optional) Determines if public access prevention is `enforced` or `inherited`.

    ex:
    ```
    bucket_public_access_prevention = "enforced"
    ```
  EOT
  type        = string
  default     = "enforced"
  validation {
    condition = contains(
      [
        "enforced",
        "inherited"
      ],
      var.bucket_public_access_prevention
    )
    error_message = "`bucket_public_access_prevention` must be either `enforced` or `inherited`."
  }
}

variable "bucket_force_destroy" {
  description = <<-EOT
    (Optional) Determines if the contents of the bucket will be deleted when a `terraform destroy` command is issued.

    ex:
    ```
    bucket_force_destroy = true
    ```
  EOT
  type        = bool
  default     = false
}

variable "bucket_uniform_level_access" {
  description = <<-EOT
    (Optional) Determines if the bucket will have uniform bucket-level access.

    ex:
    ```
    bucket_uniform_level_access = true
    ```
  EOT
  type        = bool
  default     = true
}

variable "bucket_versioning" {
  description = <<-EOT
    (Optional) Determines if object versioning is enabled on the bucket.
    If enabled, consider also using a object lifecycle to remove older versions after a period of time.

    ex:
    ```
    bucket_versioning = true
    ```
  EOT
  type        = bool
  default     = false
}

variable "bucket_encryption_key_name" {
  description = "(Optional) The encryption key name that should be used to encrypt this bucket. Default is `null`."
  type        = string
  default     = null
}

variable "cors_rules" {
  description = <<-EOT
    (Optional) List of CORS rules to configure.
    Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#cors except max_age_seconds should be a number.

    ex:
    ```
    cors_rules =
    [
      {
        origins          = ["https://*.anyscale.com"]
        methods          = ["GET", "POST", "PUT", "HEAD", "DELETE"]
        response_headers = ["*"]
        expose_headers   = ["Accept-Ranges", "Content-Range", "Content-Length"]
        max_age_seconds  = 3600
      }
    ]
    ```
  EOT

  type = set(object({
    # Object with keys:
    # - origins - (Required) List of values, with wildcards, of the Origin header in the request that an incoming OPTIONS request will be matched against.
    # - methods - (Required) Lilst of values, with wildcards, of the Access-Control-Request-Method header in the request that an incoming OPTIONS request will be matched against.
    # - response_headers - (Required) List of values, with wildcards, of the Access-Control-Request-Headers header in the request that an incoming OPTIONS request will be matched against.
    # - max_age_seconds - (Optional) The value, in seconds, to return in the Access-Control-Max-Age header used in preflight responses.
    origins          = list(string)
    methods          = list(string)
    response_headers = list(string)
    max_age_seconds  = number
  }))
  default = [
    {
      origins          = ["https://*.anyscale.com"]
      methods          = ["GET", "POST", "PUT", "HEAD", "DELETE"]
      response_headers = ["*"]
      expose_headers   = ["Accept-Ranges", "Content-Range", "Content-Length"]
      max_age_seconds  = 3600
    }
  ]
}

variable "retention_policy" {
  description = <<-EOT
    (Optional)
    Object containing a retention policy including `is_locked` and `retention_period`.

    ex:
    ```
    retention_policy = {
      is_locked = false
      retention_period = 40000000
    }
    ```
  EOT
  type        = map(string)
  default     = {}
}

# Example:
#
# lifecycle_rules = [
#   Change storage clas to NEARLINE for all objects older than 10 days
#   {
#     action = {
#       type = "SetStorageClass"
#       storage_class = "NEARLINE"
#     }
#     condition = {
#       age = "10"
#       matches_storage_class = "MULTI_REGIONAL"
#     }
#   },
#   Delete all objects older than 120 days
#   {
#     action = {
#       type = "Delete"
#     }
#     condition = {
#       age = "120"
#     }
#   },
#   Delete all versions of objects with more then 10 newer versions
#   {
#     action = {
#       type = "Delete"
#     }
#     condition = {
#       numNewerVersions = "10"
#       isLive = false
#     }
#   }
# ]
variable "lifecycle_rules" {
  description = <<-EOT
    (Optional) List of lifecycle rules to configure.
    Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#lifecycle_rule except condition.matches_storage_class should be a comma delimited string.
    Default is an empty list.
  EOT

  type = set(object({
    # Object with keys:
    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.
    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.
    action = map(string)

    # Object with keys:
    # - age - (Optional) Minimum age of an object in days to satisfy this condition.
    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.
    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".
    # - matches_storage_class - (Optional) Comma delimited string for storage class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.
    # - matches_prefix - (Optional) One or more matching name prefixes to satisfy this condition.
    # - matches_suffix - (Optional) One or more matching name suffixes to satisfy this condition.
    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.
    # - custom_time_before - (Optional) A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when the customTime metadata for the object is set to an earlier date than the date used in this lifecycle condition.
    # - days_since_custom_time - (Optional) The number of days from the Custom-Time metadata attribute after which this condition becomes true.
    # - days_since_noncurrent_time - (Optional) Relevant only for versioned objects. Number of days elapsed since the noncurrent timestamp of an object.
    # - noncurrent_time_before - (Optional) Relevant only for versioned objects. The date in RFC 3339 (e.g. 2017-06-13) when the object became nonconcurrent.
    condition = map(string)
  }))
  default = []
}

variable "bucket_logging" {
  description = <<-EOT
    (Optional) Map of bucket logging config object.
    Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#logging

    ex:
    ```
    bucket_logging = {
      log_bucket = "logging_bucket_name",
      log_object_prefix = "/prefix/"
    }
  EOT
  type        = any
  default     = {}
}

variable "bucket_iam_members" {
  description = <<-EOT
    (Optional) List of members to add to the bucket IAM binding.

    ex:
    ```
    bucket_iam_members = ["user:anyscale-access-7e337e0b@anyscale-gcp-pub.iam.gserviceaccount.com"]
    ```
  EOT
  type        = list(string)
  default     = []
}

variable "bucket_iam_member_roles" {
  description = <<-EOT
    (Optional) List of roles to add to the bucket IAM members.

    ex:
    ```
    bucket_iam_binding_roles = ["roles/storage.objectAdmin", "roles/storage.legacyBucketReader"]
    ```
  EOT
  type        = list(string)
  default     = ["roles/storage.objectAdmin", "roles/storage.legacyBucketReader", "roles/storage.folderAdmin"]
}

variable "bucket_iam_member_additional_roles" {
  description = <<-EOT
    (Optional) List of roles that provide additional roles to the default bucket IAM member roles.

    ex:
    ```
    bucket_iam_member_additional_roles = ["roles/storage.folderAdmin", "roles/storage.legacyBucketOwner"]
    ```
  EOT
  type        = list(string)
  default     = []
}
