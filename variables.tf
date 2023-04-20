# ------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
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
}

variable "anyscale_organization_id" {
  description = <<-EOT
    (Required) Anyscale Organization ID.
    This is the ID of the Anyscale Organization. This is not the same as the GCP Organization ID.
    The Organization ID will be used to lock down the cross account access from Anyscale.
    You can find the Anyscale Organization ID by going to the Anyscale UI while logged in as an Organization Owner,
    and clicking on you're username, then clicking on Organization.
    This is required.
  EOT
  type        = string
  validation {
    condition = (
      length(var.anyscale_organization_id) > 4 &&
      substr(var.anyscale_organization_id, 0, 4) == "org_"
    )
    error_message = "The anyscale_organization_id value must start with \"org_\"."
  }
}

# variable "firewall_ingress_allow_access_from_cidr_range" {
#   description = <<-EOT
#     (Required) Comma delimited string of IPv4 CIDR ranges to allow access to anyscale resources.
#     This should be the list of CIDR ranges that have access to Anyscale Clusters.
#     Public or private IPs are supported. SSH and HTTPs
#     ports will be opened to these CIDR ranges.
#     ex: "10.0.1.0/24,24.1.24.24/32"
#   EOT
#   type        = string
# }

# ------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------
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
  description = <<-EOT
    (Optional)
    A map of default labels to be added to all resources that accept labels.
    Resource dependent labels will be appended to this list.
    ex:
    ```
    labels = {
      application = "Anyscale",
      environment = "prod"
    }
    ```
    Default is an empty map.
  EOT
  type        = map(string)
  default     = {}
}

variable "common_prefix" {
  description = <<-EOT
    (Optional)
    A common prefix to add to resources created (where prefixes are allowed).
    If paired with `use_common_name`, this will apply to all resources.
    If this is not paired with `use_common_name`, this applies to:
      - CloudStorage Buckets
      - IAM Resources
      - Security Groups
    Resource specific prefixes override this variable.
    Max length is 30 characters.
    Default is `null`
  EOT
  type        = string
  default     = null
  validation {
    condition     = var.common_prefix == null || try(length(var.common_prefix) <= 30, false)
    error_message = "common_prefix must either be `null` or less than 30 characters."
  }
}

variable "use_common_name" {
  description = <<-EOT
    (Optional)
    Determines if a standard name should be used across all resources.
    If set to true and `common_prefix` is also provided, the `common_prefix` will be used prefixed to a common name.
    If set to true and `common_prefix` is not provided, the prefix will be `anyscale-`
    If set to true, this will also use a random suffix to avoid name collisions.
    Default is `false`
  EOT
  type        = bool
  default     = false
}

variable "random_char_length" {
  description = <<-EOT
    (Optional)
    Determines the random suffix length that is used to generate a common name.
    Certain Google resources have a hard limit on name lengths and this will allow
    the ability to control how many characters are added as a suffix.
    Many Google resources have a limit of 28 characters in length.
    Keep that in mind while setting this value.
    Must be >= 2 and <= 12.
    Default is `4`
  EOT
  type        = number
  default     = 4
  validation {
    condition     = try(var.random_char_length >= 2, var.random_char_length <= 12, false)
    error_message = "random_char_length must either be >= 2 and <= 12"
  }
}

# --------------------------------------------
# Project Variables
# --------------------------------------------
variable "existing_project_id" {
  description = "(Optional) An existing GCP Project ID. If provided, this will skip creating resources with the Anyscale Project module. Default is `null`."
  type        = string
  default     = null
}
variable "anyscale_project_name" {
  description = "(Optional) Google Project name. Default is `null`."
  type        = string
  default     = null
}
variable "anyscale_project_name_prefix" {
  description = <<-EOT
    (Optional) The name prefix for the project.
    If `anyscale_project_name` is provided, it will override this variable.
    The variable `general_prefix` is a fall-back prefix if this is not provided.

    Default is `null` but is set to `anyscale-project-` in a local variable.
  EOT
  type        = string
  default     = null
}
variable "anyscale_project_billing_account" {
  description = <<-EOT
    (Optional) Google Billing Account ID.
    This is required if creating a new project.
    Default is `null`.
  EOT
  type        = string
  default     = null
}
variable "anyscale_project_organization_id" {
  description = <<-EOF
    (Optional) Google Cloud Organization ID.
    Conflicts with `anyscale_project_folder_id`. If `anyscale_project_folder_id` is provided, it will be used and `organization_id` will be ignored.
    Changing this forces the project to be migrated to the newly specified organization.
    Default is `null`.
  EOF
  type        = string
  default     = null
}
variable "anyscale_project_folder_id" {
  description = <<-EOF
    (Optional) The ID of a Google Cloud Folder.
    Conflicts with `anyscale_project_organization_id`. If `anyscale_project_folder_id` is provided, it will be used and `anyscale_project_organization_id` will be ignored.
    Changing this forces the project to be migrated to the newly specified folder.
    Default is `null`.
  EOF
  type        = string
  default     = null
}

variable "anyscale_project_labels" {
  description = <<-EOT
    (Optional)
    A map of labels to be added to the Anyscale Project.
    ex:
    ```
    anyscale_project_labels = {
      application = "Anyscale",
      environment = "prod"
    }
    ```
    Default is an empty map.
  EOT
  type        = map(string)
  default     = {}
}

# --------------------------------------------
# API Module Variables
# --------------------------------------------
variable "enable_google_apis" {
  description = <<-EOT
    (Optional) Determines if the required Google APIs are enabled.
    Default is `true`.
  EOT
  type        = bool
  default     = true
}

# --------------------------------------------
# VPC Variables
# --------------------------------------------
variable "existing_vpc_name" {
  description = <<-EOT
    (Optional) An existing VPC Name.
    If provided, this module will skip creating a new VPC with the Anyscale VPC module.
    A Subnet ID (`existing_vpc_subnet_id`) is also required if this is provided.
    Default is `null`.
  EOT
  type        = string
  default     = null
}
variable "existing_vpc_subnet_name" {
  description = <<-EOT
    (Optional) Existing subnet name to create Anyscale resources in.
    If provided, this will skip creating resources with the Anyscale VPC module.
    VPC ID is also required if this is provided.
    Default is `null`.
  EOT
  type        = string
  default     = null
}
# variable "existing_vpc_private_route_table_ids" {
#   description = <<-EOT
#     (Optional)
#     Existing VPC Private Route Table IDs.
#     If provided, this will map new private subnets to these route table IDs.
#     If no new subnets are created, these route tables will be used to create VPC Endpoint(s).
#   EOT
#   type        = list(string)
#   default     = []
# }
# variable "existing_vpc_public_route_table_ids" {
#   description = <<-EOT
#     (Optional)
#     Existing VPC Public Route Table IDs.
#     If provided, these route tables will be used to create VPC Endpoint(s).
#   EOT
#   type        = list(string)
#   default     = []
# }

variable "anyscale_vpc_name" {
  description = "(Optional) VPC name. Default is `null`."
  type        = string
  default     = null
}
variable "anyscale_vpc_name_prefix" {
  description = <<-EOT
    (Optional) The prefix of the VPC name.
    Creates a unique VPC name beginning with the specified prefix.
    If `anyscale_vpc_name` is provided, it will override this variable.
    The variable `general_prefix` is a fall-back prefix if this is not provided.

    Default is `null` but is set to `anyscale-vpc-` in a local variable.
  EOT
  type        = string
  default     = null
}
variable "anyscale_vpc_description" {
  description = "(Optional) The description of the VPC. Default is `VPC for Anyscale Resources`."
  type        = string
  default     = "VPC for Anyscale Resources"
}

variable "anyscale_vpc_public_subnet_cidr" {
  description = <<-EOT
    (Optional) The public subnet to create.
    This VPC terraform will only create one public subnet in one region.
    example:
      anyscale_vpc_public_subnet_cidr = "10.100.0.0/20"
    Default is `null`.
  EOT
  type        = string
  default     = null
  validation {
    condition = (
      var.anyscale_vpc_public_subnet_cidr == null ||
      (
        try(length(regexall("/[0-9]+", var.anyscale_vpc_public_subnet_cidr)), 0) > 0 &&
        can(cidrsubnet(var.anyscale_vpc_public_subnet_cidr, 0, 0))
      )
    )
    error_message = "The `anyscale_vpc_public_subnet_cidr` CIDR block is invalid."
  }

  validation {
    condition = (
      var.anyscale_vpc_public_subnet_cidr == null ||
      (
        try(length(regexall("/[0-9]+", var.anyscale_vpc_public_subnet_cidr)), 0) > 0 &&
        can(cidrsubnet(var.anyscale_vpc_public_subnet_cidr, 0, 0)) &&
        try(length(cidrnetmask(var.anyscale_vpc_public_subnet_cidr)), 0) <= 24 &&
        try(length(cidrnetmask(var.anyscale_vpc_public_subnet_cidr)), 0) >= 8
      )
    )
    error_message = "The `anyscale_vpc_public_subnet_cidr` CIDR block must have a prefix length between /8 and /24."
  }
}

variable "anyscale_vpc_private_subnet_cidr" {
  description = <<-EOT
    (Optional) The private subnet to create.
    The Anyscale VPC module will only create one private subnet in one region.
    example:
      anyscale_vpc_private_subnet_cidr = "10.100.0.0/20"
    We recommend a /20 or larger CIDR block, but will accept a /24 or larger with a warning.
    Default is `null`.
  EOT
  type        = string
  default     = null

  validation {
    condition = (
      var.anyscale_vpc_private_subnet_cidr == null ||
      (
        try(length(regexall("/[0-9]+", var.anyscale_vpc_private_subnet_cidr)), 0) > 0 &&
        can(cidrsubnet(var.anyscale_vpc_private_subnet_cidr, 0, 0))
      )
    )
    error_message = "The `anyscale_vpc_private_subnet_cidr` CIDR block is invalid."
  }

  validation {
    condition = (
      var.anyscale_vpc_private_subnet_cidr == null ||
      (
        try(length(regexall("/[0-9]+", var.anyscale_vpc_private_subnet_cidr)), 0) > 0 &&
        can(cidrsubnet(var.anyscale_vpc_private_subnet_cidr, 0, 0)) &&
        try(length(cidrnetmask(var.anyscale_vpc_private_subnet_cidr)), 0) <= 24 &&
        try(length(cidrnetmask(var.anyscale_vpc_private_subnet_cidr)), 0) >= 8
      )
    )
    error_message = "The `anyscale_vpc_private_subnet_cidr` CIDR block must have a prefix length between /8 and /24."
  }
}

variable "anyscale_vpc_create_natgw" {
  description = <<-EOT
    (Optional) Determines if a NAT Gateway is created.
    `anyscale_vpc_private_subnet_cidr` must also be specified for this resource to be created.
    Default is `true`.
  EOT
  type        = bool
  default     = true
}

# --------------------------------------------
# Anyscale VPC Firewall Variables
# --------------------------------------------
variable "enable_anyscale_vpc_firewall" {
  description = <<-EOT
    (Optional) Determines if the Anyscale VPC Firewall is created.
    Default is `true`.
  EOT
  type        = bool
  default     = true
}
variable "anyscale_vpc_firewall_policy_name" {
  description = <<-EOT
    (Optional) The name of the Anyscale VPC Firewall Policy.
    Default is `null`.
  EOT
  type        = string
  default     = null
}

variable "anyscale_vpc_firewall_policy_description" {
  description = <<-EOT
    (Optional) The description of the Anyscale VPC Firewall Policy.
    Default is `Anyscale VPC Firewall Policy`.
  EOT
  type        = string
  default     = "Anyscale VPC Firewall Policy"
}

variable "allow_ssh_from_google_ui" {
  description = <<-EOT
    (Optional) Determines if SSH access is allowed from the Google UI.
    Default is `true`.
  EOT
  type        = bool
  default     = true
}
variable "anyscale_vpc_firewall_allow_access_from_cidrs" {
  description = <<-EOT
    (Required) Comma delimited string of IPv4 CIDR range to allow access to anyscale resources.
    This should be the list of CIDR ranges that have access to the clusters. Public or private IPs are supported.
    SSH and HTTPs ports will be opened to these CIDR ranges.
    ex: "10.0.1.0/24,24.1.24.24/32"
  EOT
  type        = string
}

# --------------------------------------------
# Anyscale Cloud Storage Variables
# --------------------------------------------
variable "enable_anyscale_gcs" {
  description = <<-EOT
    (Optional) Determines if the Anyscale Cloud Storage bucket is created.
    Default is `true`.
  EOT
  type        = bool
  default     = true
}

variable "existing_cloudstorage_bucket_name" {
  description = <<-EOT
    (Optional)
    The name of an existing S3 bucket that you'd like to use.
    Please make sure that it meets the minimum requirements for Anyscale including:
      - Bucket Policy
      - CORS Policy
      - Encryption configuration
    Default is `null`
  EOT
  type        = string
  default     = null
}

variable "anyscale_bucket_name" {
  description = <<-EOT
    (Optional - forces new resource)
    The name of the bucket used to store Anyscale related logs and other shared resources.
    If left `null`, will default to anyscale_bucket_prefix.
    If provided, overrides the anyscale_bucket_prefix variable.
    Conflicts with anyscale_bucket_prefix.
    Default is `null`.
  EOT
  type        = string
  default     = null
}

variable "anyscale_bucket_prefix" {
  description = <<-EOT
    (Optional - forces new resource)
    Creates a unique bucket name beginning with the specified prefix.
    If `anyscale_bucket_name` is provided, it will override this variable.
    The variable `general_prefix` is a fall-back prefix if this is not provided.
    Default is `null` but is set to `anyscale-` in a local variable.
  EOT
  type        = string
  default     = null
}

variable "anyscale_bucket_location" {
  description = <<-EOT
    (Optional) The location of the bucket.
    Default is `US`.
  EOT
  type        = string
  default     = "US"
}

variable "anyscale_bucket_storage_class" {
  description = <<-EOF
    (Optional)
    The bucket storage class.
    Must be one of: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE
    Default is `STANDARD`
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
      var.anyscale_bucket_storage_class
    )
    error_message = "`anyscale_bucket_storage_class` must be one of: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
  }
}

variable "anyscale_bucket_lifecycle_rules" {
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

variable "anyscale_bucket_cors_rules" {
  description = <<-EOT
    (Optional) List of CORS rules to configure.
    Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#cors except max_age_seconds should be a number.
    Default is:
    [
      {
        origins          = ["https://console.anyscale.com"]
        methods          = ["GET"]
        response_headers = ["*"]
        max_age_seconds  = 3600
      }
    ]
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
      origins          = ["https://console.anyscale.com"]
      methods          = ["GET"]
      response_headers = ["*"]
      max_age_seconds  = 3600
    }
  ]
}

variable "bucket_iam_binding_override_roles" {
  description = <<-EOT
    (Optional) List of roles to grant to the Anyscale Service Accounts.
    This allows you to override the defaults in the google-anyscale-cloudstorage module.
    Default is an empty list but will be populated with the following roles via the module: ["roles/storage.objectAdmin", "roles/storage.legacyBucketReader"]
  EOT
  type        = list(string)
  default     = []
}

# --------------------------------------------
# Anyscale Filestore Variables
# --------------------------------------------
variable "enable_anyscale_filestore" {
  description = <<-EOT
    (Optional) Determines if the Anyscale Filestore is created.
    Default is `true`.
  EOT
  type        = bool
  default     = true
}

variable "existing_filestore_instance_name" {
  description = <<-EOT
    (Optional)
    The name of an existing Filestore instance that you'd like to use.
    Default is `null`
  EOT
  type        = string
  default     = null
}

variable "anyscale_filestore_name" {
  description = <<-EOT
    (Optional - forces new resource)
    The name of the filestore instance used to store Anyscale related logs and other shared resources.
    If left `null`, will default to anyscale_filestore_name_prefix.
    If provided, overrides the anyscale_filestore_name_prefix variable.
    Conflicts with anyscale_filestore_name_prefix.
    Default is `null`.
  EOT
  type        = string
  default     = null
}

variable "anyscale_filestore_name_prefix" {
  description = <<-EOT
    (Optional - forces new resource)
    Creates a unique filestore instance name beginning with the specified prefix.
    If `anyscale_filestore_name` is provided, it will override this variable.
    The variable `general_prefix` is a fall-back prefix if this is not provided.
    Default is `null` but is set to `anyscale-` in a local variable.
  EOT
  type        = string
  default     = null
}

variable "anyscale_filestore_fileshare_name" {
  description = <<-EOT
    (Optional - forces new resource)
    The name of the fileshare to create.
    If left `null`, will default to `common_name`.
    If `common_name` is null or over 16 chars, will default to `anyscale`.
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

variable "anyscale_filestore_description" {
  description = <<-EOT
    (Optional) The description of the filestore instance.
    Default is `Anyscale Filestore Instance`.
  EOT
  type        = string
  default     = "Anyscale Filestore Instance"
}

variable "anyscale_filestore_tier" {
  description = <<-EOT
    (Optional) The tier of the filestore to create.
    Must be one of `STANDARD`, `BASIC_HDD`, `BASIC_SSD`, `HIGH_SCALE_SSD`, `ENTERPRISE` or `PREMIUM`.
    Default is `ENTERPRISE`.
  EOT
  type        = string
  default     = "ENTERPRISE"
  validation {
    condition     = contains(["STANDARD", "PREMIUM", "BASIC_HDD", "BASIC_SSD", "HIGH_SCALE_SSD", "ENTERPRISE"], var.anyscale_filestore_tier)
    error_message = "The `anyscale_filestore_tier` must be one of `STANDARD`, `BASIC_HDD`, `BASIC_SSD`, `HIGH_SCALE_SSD`, `ENTERPRISE` or `PREMIUM`."
  }
}

variable "anyscale_filestore_location" {
  description = <<-EOT
    (Optional) The name of the location region in which the filestore resource will be created.
    This can be a region for `ENTERPRISE` tier instances.
    If it is not provided, the region for the VPC network will be used
    If a VPC network was not created, provider region is used.
    Default is `null`.
  EOT
  type        = string
  default     = null
}

variable "anyscale_filestore_capacity_gb" {
  description = <<-EOT
    (Optional) The capacity of the fileshare in GB.
    This must be at least 1024 GiB for the standard tier, or 2560 GiB for the premium tier.
    Default is `2560`.
  EOT
  type        = number
  default     = 2560
  validation {
    condition     = var.anyscale_filestore_capacity_gb >= 1024
    error_message = "The `anyscale_filestore_capacity_gb` must be at least 1024 GiB for the standard tier, or 2560 GiB for the premium tier."
  }
}
# --------------------------------------------
# Anyscale IAM Variables
# --------------------------------------------
variable "enable_anyscale_iam" {
  description = <<-EOT
    (Optional) Determines if the Anyscale IAM resources are created.
    Default is `true`.
  EOT
  type        = bool
  default     = true
}

variable "anyscale_iam_access_role_name" {
  description = <<-EOT
    (Optional - forces new resource)
    The name of the IAM role that will be created for Anyscale access.
    If left `null`, will default to anyscale_iam_access_role_name_prefix.
    If provided, overrides the anyscale_iam_access_role_name_prefix variable.
    Conflicts with anyscale_iam_access_role_name_prefix.
    Default is `null`.
  EOT
  type        = string
  default     = null
}
variable "anyscale_iam_access_role_name_prefix" {
  description = <<-EOT
    (Optional - forces new resource)
    Creates a unique IAM role name beginning with the specified prefix.
    If `anyscale_iam_access_role_name` is provided, it will override this variable.
    The variable `general_prefix` is a fall-back prefix if this is not provided.
    Default is `null` but is set to `anyscale-crossacct-` in a local variable.
  EOT
  type        = string
  default     = null
}
variable "anyscale_iam_access_role_description" {
  description = <<-EOT
    (Optional) The description of the IAM role that will be created for Anyscale access.
    Default is `null`.
  EOT
  type        = string
  default     = null
}
variable "anyscale_workload_identity_pool_name" {
  description = <<-EOT
    (Optional) The name of the workload identity pool.
    If it is not provided, the Anyscale Access role name is used.
    Default is `null`.
  EOT
  type        = string
  default     = null
}
variable "anyscale_workload_identity_pool_display_name" {
  description = <<-EOT
    (Optional) The display name of the workload identity pool.
    Must be less than or equal to 32 chars.
    Default is `Anyscale Cross Account AWS Access`.
  EOT
  type        = string
  default     = "Anyscale Cross Account Access"
}
variable "anyscale_workload_identity_pool_description" {
  description = <<-EOT
    (Optional) The description of the workload identity pool.
    Default is `Used to provide Anyscale access from AWS.`.
  EOT
  type        = string
  default     = "Used to provide Anyscale access from AWS."
}
variable "anyscale_workload_identity_pool_provider_name" {
  description = <<-EOT
    (Optional) The name of the workload identity pool provider.
    If it is not provided, the Anyscale Access role name is used.
    Default is `null`.
  EOT
  type        = string
  default     = null
}
variable "anyscale_workload_identity_account_id" {
  description = <<-EOT
    (Optional) The AWS Account ID for Anyscale. Only use this if you are instructed to do so.
    This will override the sub-module variable: `anyscale_aws_account_id`
    Default is `null`.
  EOT
  type        = string
  default     = null
}

variable "anyscale_cluster_node_role_name" {
  description = <<-EOT
    (Optional - forces new resource)
    The name of the IAM role that will be created for Anyscale cluster nodes.
    If left `null`, will default to anyscale_cluster_node_role_name_prefix.
    If provided, overrides the anyscale_cluster_node_role_name_prefix variable.
    Conflicts with anyscale_cluster_node_role_name_prefix.
    Default is `null`.
  EOT
  type        = string
  default     = null
}
variable "anyscale_cluster_node_role_name_prefix" {
  description = <<-EOT
    (Optional - forces new resource)
    Creates a unique IAM role name beginning with the specified prefix.
    If `anyscale_cluster_node_role_name` is provided, it will override this variable.
    The variable `general_prefix` is a fall-back prefix if this is not provided.
    Default is `null` but is set to `anyscale-cluster-` in a local variable.
  EOT
  type        = string
  default     = null
}
variable "anyscale_cluster_node_role_description" {
  description = <<-EOT
    (Optional) The description of the IAM role that will be created for Anyscale access.
    Default is `null`.
  EOT
  type        = string
  default     = null
}
