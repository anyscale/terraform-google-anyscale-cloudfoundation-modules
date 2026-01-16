# ------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ------------------------------------------------------------------------------
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


# ------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------
variable "anyscale_deploy_env" {
  description = <<-EOT
    (Optional) Anyscale deploy environment.

    Used in resource names and tags.

    ex:
    ```
    anyscale_deploy_env = "production"
    ```
  EOT
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
  description = <<-EOT
    (Optional) Anyscale Cloud ID.

    This is the ID of the Anyscale Cloud. This is not the same as the GCP Project ID. Used in labels.

    ex:
    ```
    anyscale_cloud_id = "cld_1234567890"
    ```
  EOT
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
    (Optional) A map of labels.

    Labels to be added to all resources that accept labels.
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
    (Optional) Common Prefix for all resources.

    A common prefix to add to resources created (where prefixes are allowed).
    If paired with `use_common_name`, this will apply to all resources.
    If this is not paired with `use_common_name`, this applies to:
      - CloudStorage Buckets
      - IAM Resources
      - Security Groups
    Resource specific prefixes override this variable.
    Max length is 30 characters.

    ex:
    ```
    common_prefix = "anyscale-"
    ```
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
    (Optional) Determines if a standard name should be used across all resources.

    - If set to true and `common_prefix` is also provided, the `common_prefix` will be used and prefixed to a common name.
    - If set to true and `common_prefix` is not provided, the prefix will be `anyscale-`
    - If set to true, this will also use a random suffix to avoid name collisions.

    ex:
    ```
    use_common_name = true
    ```
  EOT
  type        = bool
  default     = false
}

variable "random_char_length" {
  description = <<-EOT
    (Optional) Random suffix character length

    Determines the random suffix length that is used to generate a common name.

    Certain Google resources have a hard limit on name lengths and this will allow
    the ability to control how many characters are added as a suffix.
    Many Google resources have a limit of 28 characters in length.
    Keep that in mind while setting this value.
    Must be >= 2 and <= 12.

    ex:
    ```
    random_char_length = 4
    ```
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
  description = <<-EOT
    (Optional) An existing GCP Project ID.

    If provided, this will skip creating resources with the Anyscale Project module.

    ex:
    ```
    existing_project_id = "my-project-id"
    ```
  EOT
  type        = string
  default     = null
}
variable "anyscale_project_name" {
  description = <<-EOT
    (Optional) Google Project name.

    Google Project Name to create.

    ex:
    ```
    anyscale_project_name = "anyscale-project"
    ```
  EOT
  type        = string
  default     = null
}
variable "anyscale_project_name_prefix" {
  description = <<-EOT
    (Optional) The name prefix for the project.

    If `anyscale_project_name` is provided, it will override this variable.
    The variable `common_prefix` is a fall-back prefix if this is not provided.

    Default is `null` but is set to `anyscale-project-` in a local variable.

    ex:
    ```
    anyscale_project_name_prefix = "anyscale-project-"
    ```
  EOT
  type        = string
  default     = null
}
variable "anyscale_project_billing_account" {
  description = <<-EOT
    (Optional) Google Billing Account ID.

    This is required if creating a new project.

    ex:
    ```
    anyscale_project_billing_account = "123456-123456-123456"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_project_organization_id" {
  description = <<-EOT
    (Optional) Google Cloud Organization ID.

    Conflicts with `anyscale_project_folder_id`. If `anyscale_project_folder_id` is provided, it will be used and `organization_id` will be ignored.

    Changing this forces the project to be migrated to the newly specified organization.

    ex:
    ```
    anyscale_project_organization_id = "1234567890"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_project_folder_id" {
  description = <<-EOT
    (Optional) The ID of a Google Cloud Folder.

    Conflicts with `anyscale_project_organization_id`. If `anyscale_project_folder_id` is provided, it will be used and `anyscale_project_organization_id` will be ignored.

    Changing this forces the project to be migrated to the newly specified folder.

    ex:
    ```
    anyscale_project_folder_id = "1234567890"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_project_labels" {
  description = <<-EOT
    (Optional) Project labels.

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

    ex:
    ```
    enable_google_apis = true
    ```
  EOT
  type        = bool
  default     = true
}

variable "enable_cloud_logging_monitoring" {
  description = <<-EOT
    (Optional) Determines if the Google Cloud Logging and Monitoring APIs are enabled.

    If this is set to `true`, the following APIs will be enabled:
      - logging.googleapis.com
      - monitoring.googleapis.com

    Additionally, the Anyscale Cluster Role will be granted access to the following roles:
      - logging.logWriter
      - monitoring.metricWriter
      - monitoring.viewer

    ex:
    ```
    enable_cloud_logging_monitoring = true
    ```
  EOT
  type        = bool
  default     = false
}

# --------------------------------------------
# VPC Variables
# --------------------------------------------
variable "existing_vpc_name" {
  description = <<-EOT
    (Optional) An existing VPC Name.

    If provided, this module will skip creating a new VPC with the Anyscale VPC module.
    An existing VPC Subnet Name (`existing_vpc_subnet_name`) is also required if this is provided.

    ex:
    ```
    existing_vpc_name = "anyscale-vpc"
    ```
  EOT
  type        = string
  default     = null
}
variable "existing_vpc_id" {
  description = <<-EOT
    (Optional) An existing VPC ID.

    If provided, this module will skip creating a new VPC with the Anyscale VPC module.
    An existing VPC Subnet Name (`existing_vpc_subnet_name`) is also required if this is provided.

    ex:
    ```
    existing_vpc_id = "projects/anyscale/global/networks/anyscale-network"
    ```
  EOT
  type        = string
  default     = null
}
variable "existing_vpc_subnet_name" {
  description = <<-EOT
    (Optional) Existing subnet name to create Anyscale resources in.

    If provided, this will skip creating resources with the Anyscale VPC module.
    An existing VPC Name (`existing_vpc_name`) is also required if this is provided.

    ex:
    ```
    existing_vpc_subnet_name = "anyscale-subnet"
    ```
  EOT
  type        = string
  default     = null
}

variable "shared_vpc_project_id" {
  description = <<-EOT
    (Optional) The ID of the project that hosts the shared VPC.

    If provided, this will set the Project ID to the Shared VPC for the `google-anyscale-vpc-firewall` submodule.
    An existing VPC Name (`existing_vpc_name`) and VPC Subnet Name (`existing_vpc_subnet_name`) are also required if this is provided.

    ex:
    ```
    shared_vpc_project_id = "anyscale-sharedvpc"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_vpc_name" {
  description = <<-EOT
    (Optional) VPC name.

    The name of the VPC to create.
    - If left `null`, will default to `anyscale_vpc_name_prefix`.
    - If provided, overrides the `anyscale_vpc_name_prefix` variable.

    ex:
    ```
    anyscale_vpc_name = "anyscale-vpc"
    ```
  EOT
  type        = string
  default     = null
}
variable "anyscale_vpc_name_prefix" {
  description = <<-EOT
    (Optional) The prefix of the VPC name.

    Creates a unique VPC name beginning with the specified prefix.
    - If `anyscale_vpc_name` is provided, it will override this variable.
    - The variable `common_prefix` is a fall-back prefix if this is not provided.
    - Default is `null` but is set to `anyscale-vpc-` in a local variable.

    ex:
    ```
    anyscale_vpc_name_prefix = "anyscale-vpc-"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_vpc_description" {
  description = <<-EOT
    (Optional) The description of the VPC.

    ex:
    ```
    anyscale_vpc_description = "Anyscale VPC"
    ```
  EOT
  type        = string
  default     = "VPC for Anyscale Resources"
}

# Public Subnet Related
variable "anyscale_vpc_public_subnet_name" {
  description = <<-EOT
    (Optional) The public subnet name.

    This VPC terraform will only create one public subnet in one region.
    Overrides `anyscale_vpc_public_subnet_suffix` if provided.

    ex:
    ```
    anyscale_vpc_public_subnet_name = "anyscale-public-subnet"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_vpc_public_subnet_suffix" {
  description = <<-EOT
    (Optional) The public subnet suffix.

    Prepended with the VPC name and region to create a unique public subnet name.
    Overridden by `anyscale_vpc_public_subnet_name`.

    ex:
    ```
    anyscale_vpc_public_subnet_suffix = "public"
    ```
  EOT
  type        = string
  default     = "public"
}

variable "anyscale_vpc_public_subnet_cidr" {
  description = <<-EOT
    (Optional) The public subnet to create.

    This VPC terraform will only create one public subnet in one region.

    ex:
    ```
    anyscale_vpc_public_subnet_cidr = "10.100.0.0/20"
    ```
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

# Private Subnet
variable "anyscale_vpc_private_subnet_name" {
  description = <<-EOT
    (Optional) The private subnet name.

    This VPC terraform will only create one private subnet in one region.
    Overrides `anyscale_vpc_private_subnet_suffix` if provided.

    ex:
    ```
    anyscale_vpc_private_subnet_name = "anyscale-private-subnet"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_vpc_private_subnet_suffix" {
  description = <<-EOT
    (Optional) The private subnet suffix.

    Prepended with the VPC name and region to create a unique private subnet name.
    Overriden by `anyscale_vpc_private_subnet_name`.

    ex:
    ```
    anyscale_vpc_private_subnet_suffix = "private"
    ```
  EOT
  type        = string
  default     = "private"
}

variable "anyscale_vpc_private_subnet_cidr" {
  description = <<-EOT
    (Optional) The private subnet to create.

    Anyscale recommends a /20 or larger CIDR block, but will accept a /24 or larger with a warning. The Anyscale VPC module will only create one private subnet in one region.

    ex:
    ```
    anyscale_vpc_private_subnet_cidr = "10.100.0.0/20"
    ```
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

# Proxy Subnet
variable "anyscale_vpc_proxy_subnet_name" {
  description = <<-EOT
    (Optional) The proxy subnet name.

    Overrides `anyscale_vpc_proxy_subnet_suffix` if provided.

    This VPC terraform will only create one proxy subnet in one region. Proxy-Only subnets are used for Google Cloud Load Balancers.
    More information can be found in the [Google Cloud Load Balancer Documentation](https://cloud.google.com/load-balancing/docs/proxy-only-subnets).

    ex:
    ```
    anyscale_vpc_proxy_subnet_name = "anyscale-proxy-subnet"
    ```
  EOT
  type        = string
  default     = null

}
variable "anyscale_vpc_proxy_subnet_suffix" {
  description = <<-EOT
    (Optional) The proxy subnet suffix.

    Prepended with the VPC name and region to create a unique proxy subnet name.
    Overridden by `anyscale_vpc_proxy_subnet_name`.

    ex:
    ```
    anyscale_vpc_proxy_subnet_suffix = "proxy"
    ```
  EOT
  type        = string
  default     = "proxy"
}

variable "anyscale_vpc_proxy_subnet_cidr" {
  description = <<-EOT
    (Optional) The proxy subnet to create.

    Anyscale recommends a /22 or larger CIDR block. The Anyscale VPC module will only create one proxy subnet in one region.
    Anyscale uses Proxy Subnets for the load balancer as part of Anyscale Services.

    ex:
    ```
    anyscale_vpc_proxy_subnet_cidr = "10.100.0.0/20"
    ```
  EOT
  type        = string
  default     = null

  validation {
    condition = (
      var.anyscale_vpc_proxy_subnet_cidr == null ||
      (
        try(length(regexall("/[0-9]+", var.anyscale_vpc_proxy_subnet_cidr)), 0) > 0 &&
        can(cidrsubnet(var.anyscale_vpc_proxy_subnet_cidr, 0, 0))
      )
    )
    error_message = "The `anyscale_vpc_proxy_subnet_cidr` CIDR block is invalid."
  }

  validation {
    condition = (
      var.anyscale_vpc_proxy_subnet_cidr == null ||
      (
        try(length(regexall("/[0-9]+", var.anyscale_vpc_proxy_subnet_cidr)), 0) > 0 &&
        can(cidrsubnet(var.anyscale_vpc_proxy_subnet_cidr, 0, 0)) &&
        try(length(cidrnetmask(var.anyscale_vpc_proxy_subnet_cidr)), 0) <= 24 &&
        try(length(cidrnetmask(var.anyscale_vpc_proxy_subnet_cidr)), 0) >= 8
      )
    )
    error_message = "The `anyscale_vpc_proxy_subnet_cidr` CIDR block must have a prefix length between /8 and /24."
  }
}

variable "anyscale_vpc_create_natgw" {
  description = <<-EOT
    (Optional) Determines if a NAT Gateway is created.

    `anyscale_vpc_private_subnet_cidr` must also be specified for this resource to be created.

    ex:
    ```
    anyscale_vpc_create_natgw = true
    ```
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

    The Anyscale VPC Firewall is a Google Cloud VPC Firewall Policy that allows access to Anyscale resources.

    ex:
    ```
    enable_anyscale_vpc_firewall = true
    ```
  EOT
  type        = bool
  default     = true
}

variable "anyscale_vpc_firewall_allow_access_from_cidrs" {
  description = <<-EOT
    (Optional) Comma delimited string of IPv4 CIDRs

    CIDR ranges to allow access to Anyscale resources. This should be the list of CIDR ranges that have access to the clusters. Public or private IPs are supported.
    HTTPS ports will be opened to these CIDR ranges. SSH is controlled by `security_group_enable_ssh_access`.

    ex:
    ```
    anyscale_vpc_firewall_allow_access_from_cidrs = "10.0.1.0/24,24.1.24.24/32"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_vpc_firewall_policy_name" {
  description = <<-EOT
    (Optional) The name of the Anyscale VPC Firewall Policy.

    ex:
    ```
    anyscale_vpc_firewall_policy_name = "anyscale-vpc-firewall-policy"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_vpc_firewall_policy_description" {
  description = <<-EOT
    (Optional) The description of the Anyscale VPC Firewall Policy.

    ex:
    ```
    anyscale_vpc_firewall_policy_description = "Anyscale VPC Firewall Policy"
    ```
  EOT
  type        = string
  default     = "Anyscale VPC Firewall Policy"
}

variable "security_group_enable_ssh_access" {
  description = <<-EOT
    (Optional) Determines if SSH access is allowed from configured CIDR ranges.

    When set to false, the SSH (port 22) firewall rule is omitted from the
    ingress CIDR rules.

    ex:
    ```
    security_group_enable_ssh_access = true
    ```
  EOT
  type        = bool
  default     = true
}

variable "allow_ssh_from_google_ui" {
  description = <<-EOT
    (Optional) Determines if SSH access is allowed from the Google UI.

    ex:
    ```
    allow_ssh_from_google_ui = true
    ```
  EOT
  type        = bool
  default     = false
}

variable "ingress_from_machine_pool_cidr_ranges" {
  description = <<-EOT
    (Optional) CIDR Range for Anyscale Machine Pools.

    If a CIDR range is provided, a firewall rule will be created to support [Anyscale Machine Pools](https://docs.anyscale.com/administration/cloud-deployment/machine-pools/).

    ex:
    ```
    ingress_from_machine_pool_cidr_ranges = ["10.100.1.0/24","10.102.1.0/24"]
    ```
  EOT

  type    = list(string)
  default = []
}

# --------------------------------------------
# Anyscale Cloud Storage Variables
# --------------------------------------------
variable "enable_anyscale_gcs" {
  description = <<-EOT
    (Optional) Determines if the Anyscale Cloud Storage bucket is created.

    ex:
    ```
    enable_anyscale_gcs = true
    ```
  EOT
  type        = bool
  default     = true
}

variable "existing_cloudstorage_bucket_name" {
  description = <<-EOT
    (Optional) Existing Cloud Storage Bucket Name.

    The name of an existing Cloud Storage bucket that you'd like to use. Please make sure that it meets the minimum requirements for Anyscale including:
      - Bucket Policy
      - CORS Policy
      - Encryption configuration

    If provided, this will skip creating a new Cloud Storage bucket with the Anyscale Cloud Storage module.

    ex:
    ```
    existing_cloudstorage_bucket_name = "anyscale-bucket"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_bucket_name" {
  description = <<-EOT
    (Optional - forces new resource) Cloudstorage bucket name.

    The name of the bucket used to store Anyscale related logs and other shared resources.
    - If left `null`, will default to `anyscale_bucket_prefix`.
    - If provided, overrides the `anyscale_bucket_prefix` variable.

    ex:
    ```
    anyscale_bucket_name = "anyscale-bucket"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_bucket_prefix" {
  description = <<-EOT
    (Optional - forces new resource) Cloudstorage bucket name prefix.

    Creates a unique bucket name beginning with the specified prefix.
    - If `anyscale_bucket_name` is provided, it will override this variable.
    - The variable `common_prefix` is a fall-back prefix if this is not provided.
    - Default is `null` but is set to `anyscale-` in a local variable.

    ex:
    ```
    anyscale_bucket_prefix = "anyscale-bucket-"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_bucket_location" {
  description = <<-EOT
    (Optional) The location of the bucket.

    ex:
    ```
    anyscale_bucket_location = "US"
    ```
  EOT
  type        = string
  default     = "US"
}

variable "anyscale_bucket_storage_class" {
  description = <<-EOT
    (Optional) Bucket storage class.

    Must be one of: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE

    ex:
    ```
    anyscale_bucket_storage_class = "STANDARD"
    ```
  EOT
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

    Format is the same as described in the [GCP provider documentation](https://www.terraform.io/docs/providers/google/r/storage_bucket.html#lifecycle_rule) except `condition.matches_storage_class` should be a comma delimited string.

    ex:
    ```
    anyscale_bucket_lifecycle_rules = [
      {
        action = {
          type          = "Delete"
          storage_class = "MULTI_REGIONAL"
        }
        condition = {
          age = 30
        }
      }
    ]
    ```
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

    ex:
    ```
    anyscale_bucket_cors_rules = [
      {
        origins          = ["https://*.anyscale.com"]
        methods          = ["GET", "HEAD, "PUT", "POST", "DELETE"]
        response_headers = ["*"]
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
      max_age_seconds  = 3600
    }
  ]
}

variable "bucket_iam_member_additional_roles" {
  description = <<-EOT
    (Optional) List of roles to grant to the Anyscale Service Accounts on the storage bucket.

    This allows you to append the defaults in the `google-anyscale-cloudstorage` module.

    Default is an empty list but will be populated with the following roles via the module: ["roles/storage.objectAdmin", "roles/storage.legacyBucketWriter", "roles/storage.folderAdmin"]

    ex:
    ```
    bucket_iam_member_additional_roles = ["roles/storage.objectAdmin"]
    ```
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

    ex:
    ```
    enable_anyscale_filestore = true
    ```
  EOT
  type        = bool
  default     = true
}

variable "existing_filestore_instance_name" {
  description = <<-EOT
    (Optional) Existing Filestore Instance Name.

    The name of an existing Filestore instance that you'd like to use.
    If provided, this will skip creating a new Filestore instance with the Anyscale Filestore module.

    ex:
    ```
    existing_filestore_instance_name = "anyscale-filestore"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_filestore_name" {
  description = <<-EOT
    (Optional - forces new resource) Filestore instance name.

    The name of the filestore instance used to store Anyscale related logs and other shared resources.
    - If left `null`, will default to `anyscale_filestore_name_prefix`.
    - If provided, overrides the `anyscale_filestore_name_prefix` variable.

    ex:
    ```
    anyscale_filestore_name = "anyscale-filestore"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_filestore_name_prefix" {
  description = <<-EOT
    (Optional - forces new resource) Filestore instance name prefix.

    Creates a unique filestore instance name beginning with the specified prefix.
    - If `anyscale_filestore_name` is provided, it will override this variable.
    - The variable `common_prefix` is a fall-back prefix if this is not provided.
    - Default is `null` but is set to `anyscale-` in a local variable.

    ex:
    ```
    anyscale_filestore_name_prefix = "anyscale-filestore-"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_filestore_fileshare_name" {
  description = <<-EOT
    (Optional - forces new resource) Filestore fileshare name.

    The name of the fileshare to create.
    - If left `null`, will default to `common_name`.
    - If `common_name` is null or over 16 chars, will default to `anyscale`.
    - Must start with a letter, followed by letters, numbers, or underscores, and cannot end with an underscore.
    - Can not be longer than 16 characters.

    ex:
    ```
    anyscale_filestore_fileshare_name = "anyscale-fileshare"
    ```
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

    ex:
    ```
    anyscale_filestore_description = "Anyscale Filestore Instance"
    ```
  EOT
  type        = string
  default     = "Anyscale Filestore Instance"
}

variable "anyscale_filestore_tier" {
  description = <<-EOT
    (Optional) The tier of the filestore to create.

    Supported values include `STANDARD`, `PREMIUM`, `BASIC_HDD`, `BASIC_SSD`, `HIGH_SCALE_SSD`, `ENTERPRISE`, `ZONAL`, and `REGIONAL`.

    ex:
    ```
    anyscale_filestore_tier = "STANDARD"
    ```
  EOT
  type        = string
  default     = "STANDARD"
  validation {
    condition     = contains(["STANDARD", "PREMIUM", "BASIC_HDD", "BASIC_SSD", "HIGH_SCALE_SSD", "ENTERPRISE", "ZONAL", "REGIONAL"], var.anyscale_filestore_tier)
    error_message = "The `anyscale_filestore_tier` must be one of `STANDARD`, `PREMIUM`, `BASIC_HDD`, `BASIC_SSD`, `HIGH_SCALE_SSD`, `ENTERPRISE`, `ZONAL`, or `REGIONAL`."
  }
}

variable "anyscale_filestore_location" {
  description = <<-EOT
    (Optional) The name of the location region in which the filestore resource will be created.

    This can be a region for `ENTERPRISE` tier instances.
    If it is not provided, the region for the VPC network will be used
    If a VPC network was not created, provider region is used.

    ex:
    ```
    anyscale_filestore_location = "us-central1"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_filestore_capacity_gb" {
  description = <<-EOT
    (Optional) The capacity of the fileshare in GB.
    This must be at least 1024 GiB for the standard or enterprise tiers, or 2560 GiB for the premium tier.
    Default is `1024`.
  EOT
  type        = number
  default     = 1024
  validation {
    condition     = var.anyscale_filestore_capacity_gb >= 1024
    error_message = "The `anyscale_filestore_capacity_gb` must be at least 1024 GiB for the standard or enterprise tiers, or 2560 GiB for the premium tier."
  }
}

variable "anyscale_filestore_labels" {
  description = <<-EOT
    (Optional) Filestore Labels

    A map of labels to be added to the Filestore instance.
    Duplicate labels in `labels` will be overwritten by labels in `anyscale_filestore_labels`.

    ex:
    ```
    anyscale_filestore_labels = {
      application = "Anyscale",
      environment = "prod"
    }
    ```
  EOT
  type        = map(string)
  default     = {}
}

variable "anyscale_filestore_network_conect_mode" {
  description = <<-EOT
    (Optional) The network connect mode of the filestore instance.

    Must be one of `DIRECT_PEERING` or `PRIVATE_SERVICE_ACCESS`. If using a Shared VPC, this must be set to `PRIVATE_SERVICE_ACCESS`.

    ex:
    ```
    anyscale_filestore_network_conect_mode = "DIRECT_PEERING"
    ```
  EOT
  type        = string
  default     = "DIRECT_PEERING"
  validation {
    condition     = contains(["DIRECT_PEERING", "PRIVATE_SERVICE_ACCESS"], var.anyscale_filestore_network_conect_mode)
    error_message = "The `anyscale_filestore_network_conect_mode` must be one of `DIRECT_PEERING` or `PRIVATE_SERVICE_ACCESS`"
  }
}

# --------------------------------------------
# Anyscale IAM Variables
# --------------------------------------------
variable "enable_anyscale_iam" {
  description = <<-EOT
    (Optional) Determines if the Anyscale IAM resources are created.

    ex:
    ```
    enable_anyscale_iam = true
    ```
  EOT
  type        = bool
  default     = true
}

variable "anyscale_iam_access_service_acct_name" {
  description = <<-EOT
    (Optional - forces new resource) IAM Access Service Account Name

    The name of the IAM role that will be created for Anyscale access.
    - If left `null`, will default to `anyscale_iam_access_service_acct_name_prefix`.
    - If provided, overrides the `anyscale_iam_access_service_acct_name_prefix` variable.
    - It needs to be > 4 chars and < 28 chars.

    ex:
    ```
    anyscale_iam_access_service_acct_name = "anyscale-crossacct-access"
    ```
  EOT
  type        = string
  default     = null
  validation {
    condition = var.anyscale_iam_access_service_acct_name == null ? true : (
      can(regex("^(?:[a-z](?:[-a-z0-9]{4,28}[a-z0-9])?)$", var.anyscale_iam_access_service_acct_name))
    )
    error_message = "`anyscale_iam_access_service_acct_name` must start with a lowercase letter followed by up to 28 lowercase letters, numbers, or hyphens."
  }
}
variable "anyscale_iam_access_service_acct_name_prefix" {
  description = <<-EOT
    (Optional - forces new resource) IAM Access Role Name Prefix

    Creates a unique IAM Service Account name beginning with the specified prefix.
    - If `anyscale_iam_access_service_acct_name` is provided, it will override this variable.
    - The variable `common_prefix` is a fall-back prefix if this is not provided.
    - Default is `null` but is set to `anyscale-crossacct-` in a local variable.
    - It needs to be > 4 chars and < 20 chars.

    ex:
    ```
    anyscale_iam_access_service_acct_name_prefix = "anyscale-crossacct-"
    ```
  EOT
  type        = string
  default     = null
  validation {
    condition = var.anyscale_iam_access_service_acct_name_prefix == null ? true : (
      can(regex("^(?:[a-z](?:[-a-z0-9]{4,20})?)$", var.anyscale_iam_access_service_acct_name_prefix))
    )
    error_message = "`anyscale_iam_access_service_acct_name_prefix` must start with a lowercase letter followed by up to 20 lowercase letters, numbers, or hyphens."
  }
}
variable "anyscale_iam_access_service_acct_description" {
  description = <<-EOT
    (Optional) The description of the IAM role that will be created for Anyscale access.

    ex:
    ```
    anyscale_iam_access_service_acct_description = "Anyscale Cross Account Access"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_iam_access_role_id" {
  description = <<-EOT
    (Optional, forces creation of new resource) The ID of the Anyscale IAM access role.

    Overrides `anyscale_iam_access_role_id_prefix`.

    ex:
    ```
    anyscale_iam_access_role_id = "anyscale_access_role"
    ```
  EOT
  type        = string
  default     = null
  validation {
    condition = var.anyscale_iam_access_role_id == null ? true : (
      can(regex("^[a-zA-Z0-9_]{4,28}$", var.anyscale_iam_access_role_id))
    )
    error_message = "`anyscale_iam_access_role_id` must match regex: ^[a-zA-Z0-9_]{4,28}$."
  }
}
variable "anyscale_iam_access_role_id_prefix" {
  description = <<-EOT
    (Optional, forces creation of new resource) The prefix of the Anyscale IAM access role.

    If `anyscale_iam_access_role_id` is provided, it will override this variable.
    If set to `null`, the prefix will be set to \"anyscale_\" in a local variable.

    ex:
    ```
    anyscale_iam_access_role_id_prefix = "anyscale_crossacct_role_"
    ```
  EOT
  type        = string
  default     = "anyscale_crossacct_role_"
  validation {
    condition = var.anyscale_iam_access_role_id_prefix == null ? true : (
      can(regex("^[a-zA-Z0-9_]{4,24}$", var.anyscale_iam_access_role_id_prefix))
    )
    error_message = "`anyscale_iam_access_role_id_prefix` must match regex: ^[a-zA-Z0-9_]{4,24}$."
  }
}
variable "anyscale_access_role_description" {
  description = <<-EOT
    (Optional) The description of the Anyscale IAM access role.

    ex:
    ```
    anyscale_access_role_description = "Anyscale Cross Account Access"
    ```
  EOT
  type        = string
  default     = "Anyscale Cross Account Access Role"
}


variable "existing_workload_identity_provider_name" {
  description = <<-EOT
    (Optional) The name of an existing workload identity provider to use.

    If provided, will skip creating the workload identity pool and provider. The Workload Identity Provider can be in a different project.

    You can retrieve the name of an existing Workload Identity Provider by running the following command:
    ```
    gcloud iam workload-identity-pools providers list --location global --workload-identity-pool anyscale-access-pool
    ```

    ex:
    ```
    existing_workload_identity_provider_name = "projects/1234567890/locations/global/workloadIdentityPools/anyscale-access-pool/providers/anyscale-access-provider"
    ```
  EOT
  type        = string
  default     = null
}
variable "anyscale_workload_identity_pool_name" {
  description = <<-EOT
    (Optional) The name of the workload identity pool.

    If it is not provided, the Anyscale Access role name is used.

    ex:
    ```
    anyscale_workload_identity_pool_name = "anyscale-identitypool-access"
    ```
  EOT
  type        = string
  default     = null
  validation {
    condition = var.anyscale_workload_identity_pool_name == null ? true : (
      can(regex("^(?:[a-z](?:[-a-z0-9]{0,32}[a-z0-9])?)$", var.anyscale_workload_identity_pool_name))
    )
    error_message = "`anyscale_workload_identity_pool_name` must start with a lowercase letter followed by up to 32 lowercase letters, numbers, or hyphens, and cannot end with a hyphen."
  }
}
variable "anyscale_workload_identity_pool_display_name" {
  description = <<-EOT
    (Optional) The display name of the workload identity pool.

    Must be less than or equal to 32 chars.

    ex:
    ```
    anyscale_workload_identity_pool_display_name = "Anyscale Cross Account Access"
    ```
  EOT
  type        = string
  default     = "Anyscale Cross Account Access"
}
variable "anyscale_workload_identity_pool_description" {
  description = <<-EOT
    (Optional) The description of the workload identity pool.

    ex:
    ```
    anyscale_workload_identity_pool_description = "Used to provide Anyscale access from AWS."
    ```
  EOT
  type        = string
  default     = "Used to provide Anyscale access from AWS."
}
variable "anyscale_workload_identity_pool_provider_name" {
  description = <<-EOT
    (Optional) The name of the workload identity pool provider.

    If it is not provided, the Anyscale Access role name is used.

    ex:
    ```
    anyscale_workload_identity_pool_provider_name = "anyscale-identitypool-access"
    ```
  EOT
  type        = string
  default     = null
}
variable "anyscale_workload_identity_account_id" {
  description = <<-EOT
    (Optional) The AWS Account ID for Anyscale. Only use this if you are instructed to do so.

    This will override the sub-module variable: `anyscale_aws_account_id`

    ex:
    ```
    anyscale_workload_identity_account_id = "123456789012"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_cluster_node_service_acct_name" {
  description = <<-EOT
    (Optional - forces new resource) IAM Cluster Node Role Name

    The name of the IAM role that will be created for Anyscale cluster nodes.
    - If left `null`, will default to anyscale_cluster_node_service_acct_name_prefix.
    - If provided, overrides the anyscale_cluster_node_service_acct_name_prefix variable.
    - It needs to be > 4 chars and < 28 chars.

    ex:
    ```
    anyscale_cluster_node_service_acct_name = "anyscale-cluster-node"
    ```
  EOT
  type        = string
  default     = null
  validation {
    condition = var.anyscale_cluster_node_service_acct_name == null ? true : (
      can(regex("^(?:[a-z](?:[-a-z0-9]{4,28}[a-z0-9])?)$", var.anyscale_cluster_node_service_acct_name))
    )
    error_message = "`anyscale_cluster_node_service_acct_name` must start with a lowercase letter followed by up to 28 lowercase letters, numbers, or hyphens."
  }

}
variable "anyscale_cluster_node_service_acct_name_prefix" {
  description = <<-EOT
    (Optional - forces new resource) IAM Cluster Node Role Name Prefix

    Creates a unique IAM role name beginning with the specified prefix.
    - If `anyscale_cluster_node_service_acct_name` is provided, it will override this variable.
    - The variable `common_prefix` is a fall-back prefix if this is not provided.
    - Default is `null` but is set to `anyscale-cluster-` in a local variable.
    - It needs to be > 4 chars and < 20 chars.

    ex:
    ```
    anyscale_cluster_node_service_acct_name_prefix = "anyscale-cluster-"
    ```
  EOT
  type        = string
  default     = null
  validation {
    condition = var.anyscale_cluster_node_service_acct_name_prefix == null ? true : (
      can(regex("^(?:[a-z](?:[-a-z0-9]{4,20})?)$", var.anyscale_cluster_node_service_acct_name_prefix))
    )
    error_message = "`anyscale_cluster_node_service_acct_name_prefix` must start with a lowercase letter followed by up to 20 lowercase letters, numbers, or hyphens."
  }
}
variable "anyscale_cluster_node_service_acct_description" {
  description = <<-EOT
    (Optional) The description of the IAM role that will be created for Anyscale access.

    ex:
    ```
    anyscale_cluster_node_service_acct_description = "Anyscale Cluster Node"
    ```
  EOT
  type        = string
  default     = null
}

# --------------------------------------------
# Anyscale Memorystore Variables
# --------------------------------------------
variable "enable_anyscale_memorystore" {
  description = <<-EOT
    (Optional) Determines if the Anyscale Memorystore is created.

    ex:
    ```
    enable_anyscale_memorystore = true
    ```
  EOT
  type        = bool
  default     = false
}

variable "existing_memorystore_instance_name" {
  description = <<-EOT
    (Optional) The name of an existing Memorystore instance.

    If this is provided, the Anyscale Memorystore module will skip creating a new Memorystore instance.

    ex:
    ```
    existing_memorystore_instance_name = "anyscale-memorystore"
    ```

  EOT
  type        = string
  default     = null
}

variable "anyscale_memorystore_name" {
  description = <<-EOT
    (Optional - forces new resource) Memorystore Name

    The name of the Memorystore instance used for Anyscale Services Head Node HA.

    If left `null`, will default to `anyscale_memorystore_name_prefix`.
    If provided, overrides the `anyscale_memorystore_name_prefix` variable.

    ex:
    ```
    anyscale_memorystore_name = "anyscale-memorystore"
    ```
  EOT
  type        = string
  default     = null
  validation {
    condition = var.anyscale_memorystore_name == null ? true : (
      can(regex("^(?:[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?)$", var.anyscale_memorystore_name))
    )
    error_message = "`anyscale_memorystore_name` must start with a lowercase letter followed by up to 62 lowercase letters, numbers, or hyphens, and cannot end with a hyphen."
  }
}

variable "anyscale_memorystore_name_prefix" {
  description = <<-EOT
    (Optional - forces new resource) Memorystore Name Prefix

    Creates a unique Memorystore instance name beginning with the specified prefix.
    If `anyscale_memorystore_name` is provided, it will override this variable.

    Because it is the prefix, it can end in a hyphen as it will have a random suffix appended to it.
    The variable `common_prefix` is a fall-back prefix if this is not provided.

    ex:
    ```
    anyscale_memorystore_name_prefix = "anyscale-memorystore"
    ```
  EOT
  type        = string
  default     = null
  validation {
    condition = var.anyscale_memorystore_name_prefix == null ? true : (
      can(regex("^(?:[a-z](?:[-a-z0-9]{0,47})?)$", var.anyscale_memorystore_name_prefix))
    )
    error_message = "`anyscale_memorystore_name_prefix` must start with a lowercase letter followed by up to 48 lowercase letters, numbers, or hyphens."
  }
}

variable "anyscale_memorystore_display_name" {
  description = <<-EOT
    (Optional) Memorystore Display Name

    The display name of the Memorystore instance used for Anyscale Services Head Node HA.
    Must start with a lowercase letter followed by up to 62 lowercase letters, numbers, or hyphens, and cannot end with a hyphen.

    ex:
    ```
    anyscale_memorystore_display_name = "Anyscale Memorystore"
    ```
  EOT
  type        = string
  default     = null
}

variable "anyscale_memorystore_labels" {
  description = <<-EOT
    (Optional) Memorystore Labels

    A map of labels to be added to the Memorystore instance.
    Duplicate labels in `labels` will be overwritten by labels in `anyscale_memorystore_labels`.

    ex:
    ```
    anyscale_memorystore_labels = {
      application = "Anyscale",
      environment = "prod"
    }
    ```
  EOT
  type        = map(string)
  default     = {}
}

# --------------------------------------------
# Anyscale LoggingSink Variables
# --------------------------------------------
variable "enable_anyscale_loggingsink" {
  description = <<-EOT
    (Optional) Determines if the Anyscale Logging Sink sub-module is executed.

    This sub-module will disable sending syslog events to the `_Default` Log Sink which can lead to extra logging costs.

    ex:
    ```hcl
    enable_anyscale_loggingsink = true
    ```
  EOT
  type        = bool
  default     = true
}
