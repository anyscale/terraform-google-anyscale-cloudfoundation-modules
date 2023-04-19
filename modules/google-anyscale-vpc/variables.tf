# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
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

variable "module_enabled" {
  description = "(Optional) Whether to create the resources inside this module. Default is `true`."
  type        = bool
  default     = true
}

variable "google_region" {
  description = "The Google region in which all resources will be created. If not provided, the provider region is used. Default is `null`."
  type        = string
  default     = null
}
variable "anyscale_project_id" {
  description = "(Optional) The ID of the project to create the resource in. If it is not provided, the provider project is used. Default is `null`."
  type        = string
  default     = null
}

variable "anyscale_vpc_name" {
  description = <<-EOT
    (Optional) The name of the VPC.
    This overrides the `anyscale_vpc_prefix` parameter.
    Default is `null`.
  EOT
  type        = string
  default     = null
}
variable "anyscale_vpc_name_prefix" {
  description = <<-EOT
    (Optional) The prefix of the VPC name.
    Creates a unique VPC name beginning with the specified prefix.
    Default is `anyscale-`.
  EOT
  type        = string
  default     = "anyscale-"
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

variable "vpc_description" {
  description = "(Optional) The description of the VPC. Default is `VPC for Anyscale Resources`."
  type        = string
  default     = "VPC for Anyscale Resources"
}

variable "routing_mode" {
  description = <<-EOT
    (Optional) The network routing mode.
    Must be one of `REGIONAL` or `GLOBAL`.
    Default is `REGIONAL`
  EOT
  type        = string
  default     = "REGIONAL"
  validation {
    condition     = contains(["REGIONAL", "GLOBAL"], var.routing_mode)
    error_message = "The routing_mode value must be either `REGIONAL` or `GLOBAL`."
  }
}

variable "auto_create_subnets" {
  description = <<-EOT
    (Optional) Determines if the network is created in 'auto subnet mode'.
    If set to `true`, a subnet will be created for each region automatically across the 10.128.0.0/9 address range.
    When set to false, the network is created in 'custom subnet mode' so the user can explicitly create subnetwork resources.
    Default is `false`.
  EOT
  type        = bool
  default     = false
}

variable "delete_default_internet_gateway_routes" {
  description = <<-EOT
    (Optional) Determines if all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted.
    Default is `false`.
  EOT
  type        = bool
  default     = false
}

variable "vpc_mtu" {
  description = <<-EOT
    (Optional) The network MTU
    If set to`0`, meaning MTU is unset, the MTU will deafult to '1460'.
    Recommended values: 1460 (default for historic reasons), 1500 (Internet default), or 8896 (for Jumbo packets).
    Allowed are all values in the range 1300 to 8896, inclusively.
    Default is `0`.
  EOT
  type        = number
  default     = 0
}

#------------------------------------------------------------------------------
# Subnets
#------------------------------------------------------------------------------
variable "public_subnet_cidr" {
  description = <<-EOT
    (Optional) The public subnet to create.
    This VPC terraform will only create one public subnet in one region.
    example:
      public_subnet_cidr = "10.100.0.0/24"
    Default is `null`.
  EOT
  type        = string
  default     = null
}
variable "existing_public_subnet_id" {
  description = <<-EOT
    (Optional) The existing public subnet ID to use.
    This VPC terraform will only create subnets in one region.
    example:
      existing_public_subnet_id = "projects/anyscale/regions/us-central1/subnetworks/subnet-1"
    Default is `null`.
  EOT
  type        = string
  default     = null
}

variable "public_subnet_name" {
  description = <<-EOT
    (Optional) Explicit name for the public subnet.
    If empty, the public subnet name will be generated using the `public_subnet_suffix` parameter.
    Default is `null`.
  EOT
  type        = string
  default     = null
}
variable "public_subnet_suffix" {
  description = <<-EOT
    (Optional) The suffix of the public subnet name.
    Creates a unique public subnet name ending with the specified suffix.
    Default is `public`.
  EOT
  type        = string
  default     = "public"
}

variable "public_subnet_google_api_access" {
  description = "(Optional) Determines if the public subnet has access to Google APIs. Default is `true`."
  type        = bool
  default     = true
}
variable "public_subnet_flow_log_config" {
  description = <<-EOT
    (Optional) The configuration options for public subnet flow logging.
    example:
      public_subnet_flow_log_config = {
        aggregation_interval = "INTERVAL_5_SEC"
        flow_sampling        = 0.5
        metadata             = "INCLUDE_ALL_METADATA"
      }
    Default is an empty map.
  EOT
  type        = map(string)
  default     = {}
}
variable "public_subnet_description" {
  description = "(Optional) The description of the public subnets. Default is `null`."
  type        = string
  default     = null
}
variable "public_subnet_stack_type" {
  description = "(Optional) The stack type of the public subnet. Must be one of `IPV4_ONLY` or `IPV4_IPV6`. Default is `IPV4_ONLY`."
  type        = string
  default     = "IPV4_ONLY"
  validation {
    condition     = contains(["IPV4_ONLY", "IPV4_IPV6"], var.public_subnet_stack_type)
    error_message = "The `public_subnet_stack_type` must be one of `IPV4_ONLY` or `IPV4_IPV6`."
  }
}
variable "public_subnet_ipv6_type" {
  description = "(Optional) The IPv6 type of the public subnet. Must be one of `EXTERNAL`, `INTERNAL`, or `null`. Default is `null`."
  type        = string
  default     = null
  validation {
    condition = (
      var.public_subnet_ipv6_type == null ? true : (
        contains(["EXTERNAL", "INTERNAL"], var.public_subnet_ipv6_type)
      )
    )
    error_message = "The `public_subnet_ipv6_type` must be one of `EXTERNAL`, `INTERNAL`, or `null` which is the default."
  }
}

# Private Subnets
variable "private_subnet_cidr" {
  description = <<-EOT
    (Optional) The cidr block for the private subnet being created.
    This VPC terraform will only create one private subnet in one region.
    example:
      private_subnet = "10.100.0.0/24"
    Default is `null`.
  EOT
  type        = string
  default     = null
}
variable "existing_private_subnet_id" {
  description = <<-EOT
    (Optional) The existing private subnet ID to use.
    This VPC terraform will only create subnets in one region.
    example:
      existing_private_subnet_id = "projects/anyscale/regions/us-central1/subnetworks/subnet-1"
    Default is `null`.
  EOT
  type        = string
  default     = null
}

variable "private_subnet_name" {
  description = <<-EOT
    (Optional) Explicit name for the private subnet.
    If empty, the public subnet name will be generated using the `private_subnet_name` parameter.
    Default is `null`.
  EOT
  type        = string
  default     = null
}
variable "private_subnet_suffix" {
  description = <<-EOT
    (Optional) The suffix of the private subnet name.
    Creates a unique private subnet name ending with the specified suffix.
    Default is `private`.
  EOT
  type        = string
  default     = "private"
}

variable "private_subnet_google_api_access" {
  description = "(Optional) Determines if the private subnet has access to Google APIs. Default is `true`."
  type        = bool
  default     = true
}
variable "private_subnet_flow_log_config" {
  description = <<-EOT
    (Optional) The configuration options for private subnet flow logging.
    example:
      ```
      private_subnet_flow_log_config = {
        aggregation_interval = "INTERVAL_10_MIN"
        flow_sampling        = 1.0
        metadata             = "EXCLUDE_ALL_METADATA"
      }
      ```
    Terraform Google Provider [documented options](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#nested_log_config)
  EOT
  type        = map(string)
  default = {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
variable "private_subnet_description" {
  description = "(Optional) The description of the private subnet. Default is `null`."
  type        = string
  default     = null
}
variable "private_subnet_stack_type" {
  description = "(Optional) The stack type of the private subnet. Must be one of `IPV4_ONLY` or `IPV4_IPV6`. Default is `IPV4_ONLY`."
  type        = string
  default     = "IPV4_ONLY"
  validation {
    condition     = contains(["IPV4_ONLY", "IPV4_IPV6"], var.private_subnet_stack_type)
    error_message = "The `private_subnet_stack_type` must be one of `IPV4_ONLY` or `IPV4_IPV6`."
  }
}
variable "private_subnet_ipv6_type" {
  description = "(Optional) The IPv6 type of the private subnet. Must be one of `EXTERNAL`, `INTERNAL`, or `null`. Default is `null`."
  type        = string
  default     = null
  validation {
    condition = (
      var.private_subnet_ipv6_type == null ? true : (
        contains(["EXTERNAL", "INTERNAL"], var.private_subnet_ipv6_type)
      )
    )
    error_message = "The `private_subnet_ipv6_type` must be one of `EXTERNAL`, `INTERNAL`, or `null` which is the default."
  }
}

# ---------------------
# NAT & Router Related
#  This is an opinionated build for a NAT gateway.
# ---------------------
variable "create_nat" {
  description = "(Optional) Whether to create a NAT gateway. Also requires `private_subnet_cidr` to be set. Default is `true`."
  type        = bool
  default     = true
}

variable "nat_name" {
  description = "(Optional) The name of the NAT. Changing this forces a new NAT to be created. If not provided, will use the `vpc-name-nat`. Default is `null`."
  type        = string
  default     = null
}

variable "nat_min_ports_per_vm" {
  description = "(Optional) Minimum number of ports allocated to a VM from this NAT config. Changing this forces a new NAT to be created.  Default is `64`."
  type        = string
  default     = "64"
}

variable "source_subnetwork_ip_ranges_to_nat" {
  description = <<-EOT
    (Optional) How NAT should be configured per Subnetwork.
    Valid values include: `ALL_SUBNETWORKS_ALL_IP_RANGES`, `ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES`, `LIST_OF_SUBNETWORKS`.
    Changing this forces a new NAT to be created.
    Default is`ALL_SUBNETWORKS_ALL_IP_RANGES`.
  EOT
  type        = string
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  validation {
    condition = contains(
      [
        "ALL_SUBNETWORKS_ALL_IP_RANGES",
        "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES",
        "LIST_OF_SUBNETWORKS"
      ],
      var.source_subnetwork_ip_ranges_to_nat
    )
    error_message = "The `source_subnetwork_ip_ranges_to_nat` must be one of `ALL_SUBNETWORKS_ALL_IP_RANGES`, `ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES`, `LIST_OF_SUBNETWORKS`."
  }
}

variable "nat_tcp_established_idle_timeout_sec" {
  description = "(Optional) Timeout (in seconds) for TCP established connections. Changing this forces a new NAT to be created. Default is `1200`."
  type        = string
  default     = "1200"
}

variable "nat_tcp_transitory_idle_timeout_sec" {
  description = "(Optional) Timeout (in seconds) for TCP transitory connections. Changing this forces a new NAT to be created. Default is `30`."
  type        = string
  default     = "30"
}

variable "nat_tcp_time_wait_timeout_sec" {
  type        = string
  description = "(Optional) Timeout (in seconds) for TCP connections that are in TIME_WAIT state. Default is `120`."
  default     = "120"
}

variable "nat_udp_idle_timeout_sec" {
  type        = string
  description = "(Optional) Timeout (in seconds) for UDP connections. Changing this forces a new NAT to be created. Default is `30`."
  default     = "30"
}

variable "nat_icmp_idle_timeout_sec" {
  type        = string
  description = "(Optional) Timeout (in seconds) for ICMP connections. Changing this forces a new NAT to be created. Default is `30`."
  default     = "30"
}

variable "nat_enable_endpoint_independent_mapping" {
  description = "(Optional) Determines if NAT endpoint independent mapping is enabled. Default is `false`."
  type        = bool
  default     = false
}

variable "nat_enable_logging" {
  description = "(Optional) Determines whether or not to export logs. Default is `false`."
  type        = bool
  default     = false
}
variable "nat_log_config_filter" {
  description = <<-EOT
    (Optional) Specifies the desired filtering of logs on this NAT.
    Valid values are: `ERRORS_ONLY`, `TRANSLATIONS_ONLY`, `ALL`.
    Default is `ALL`.
  EOT
  type        = string
  default     = "ALL"
  validation {
    condition = contains(
      [
        "ERRORS_ONLY",
        "TRANSLATIONS_ONLY",
        "ALL"
      ],
      var.nat_log_config_filter
    )
    error_message = "The `nat_log_config_filter` must be one of `ERRORS_ONLY`, `TRANSLATIONS_ONLY`, `ALL`."
  }
}

# Router Options for NAT
variable "router_name" {
  description = "(Optional) The name of the router. Changing this forces a new Router to be created. If not provided, will use the `vpc-name-router`. Default is `null`."
  type        = string
  default     = null
}

variable "router_asn" {
  description = "(Optional) Router ASN. Default is `64514`."
  type        = string
  default     = "64514"
}

variable "router_keepalive_interval" {
  type        = string
  description = "(Optional) Router keepalive_interval. Default is `20`."
  default     = "20"
}

# variable "labels" {
#   description = "(Optional) A map of labels to all resources that accept labels. Default is an empty map."
#   type        = map(string)
#   default     = {}
# }
