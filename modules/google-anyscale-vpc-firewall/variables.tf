# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ------------------------------------------------------------------------------
variable "vpc_name" {
  description = <<-EOT
    (Required) The name of the VPC to apply the Firewall Policy to.
  EOT
  type        = string
}

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

variable "anyscale_project_id" {
  description = "(Optional) The ID of the project to create the resource in. If it is not provided, the provider project is used. Default is `null`."
  type        = string
  default     = null
}
# variable "google_region" {
#   description = "The Google region in which all resources will be created. If not provided, the provider region will be used. Default is `null`."
#   type        = string
#   default     = null
# }

# --------------------------------------------------------------
# Firewall Policy
# --------------------------------------------------------------
variable "firewall_policy_name" {
  description = "(Optional) The name of the firewall policy. If not provided, the firewall name will default to the vpc name. Default is `null`."
  type        = string
  default     = null
}


variable "firewall_policy_description" {
  description = "(Optional) The description of the firewall policy. Default is `Anyscale VPC Firewall Policy`."
  type        = string
  default     = "Anyscale VPC Firewall Policy"
}

#------------------------------------------------------------------------------
# Firewall Rules
#------------------------------------------------------------------------------
variable "enable_firewall_rule_logging" {
  description = "(Optional) Determines whether to enable logging for firewall rules. Default is `true`."
  type        = bool
  default     = true
}

variable "ingress_with_self_cidr_range" {
  description = "(Optional) List of CIDR range to default to if a specific mapping isn't provided. Default is an empty list."
  type        = list(string)
  default     = []
}
variable "ingress_with_self_map" {
  description = "(Optional) List of ingress rules to create where 'self' is defined. Default rule is `all-all` as this firewall rule is used for all Anyscale resources."
  type        = list(map(string))
  default     = [{ rule = "all-all" }]
}


variable "default_ingress_cidr_range" {
  description = "(Optional) List of IPv4 cidr ranges to default to if a specific mapping isn't provided (see below example). Default is an empty list."
  type        = list(string)
  default     = []
}

# ex:
# ingress_from_cidr_map = [
#   {
#     rule        = "https-443-tcp"
#     cidr_blocks = "10.100.10.10/32"
#   },
#   { rule = "nfs-tcp" },
#   {
#     rule        = "http-80-tcp"
#     cidr_blocks = "10.100.10.10/32"
#   },
#   {
#     ports       = 10-20
#     protocol    = 6
#     description = "Service name is TEST"
#     cidr_blocks = "10.100.10.10/32"
#   }
# ]
variable "ingress_from_cidr_map" {
  description = <<-EOT
    (Optional) List of ingress rules to create with cidr ranges.
    This can use rules from `predefined_firewall_rules` or custom rules.
    ex:
    ```
    ingress_from_cidr_map = [
      {
        rule        = "https-443-tcp"
        cidr_blocks = "10.100.10.10/32"
      },
      { rule = "nfs-tcp" },
      {
        ports       = "10-20"
        protocol    = "tcp"
        description = "Service name is TEST"
        cidr_blocks = "10.100.10.10/32"
      }
    ]
    ```
    Default is an empty list.
  EOT
  type        = list(map(string))
  default     = []
}

# variable "allow_all_egress" {
#   description = "(Optional) Determines of egress to all on cidr range 0.0.0.0/0 is allowed. If set to `false` then additional changes need to be made to the Firewall for Anyscale to work. Default is `true`"
#   type        = bool
#   default     = true
# }

# --------------------
# Pre-defined rules
#   These are reuqired
# --------------------
variable "predefined_firewall_rules" {
  # tflint-ignore: terraform_standard_module_structure
  description = "(Required) Map of predefined firewall rules."
  type        = map(list(any))

  default = {
    all-all = ["", "all", "All protocols", 1000]
    # HTTP
    http-80-tcp = [80, "tcp", "HTTP", 1001]
    # HTTPS
    https-443-tcp = [443, "tcp", "HTTPS", 1002]
    # SSH
    ssh-tcp = [22, "tcp", "SSH", 1003]
    # NFS
    nfs-tcp = [2049, "tcp", "NFS/EFS", 1004]
  }
}
# variable "labels" {
#   description = "(Optional) A map of labels to all resources that accept labels. Default is an empty map."
#   type        = map(string)
#   default     = {}
# }
