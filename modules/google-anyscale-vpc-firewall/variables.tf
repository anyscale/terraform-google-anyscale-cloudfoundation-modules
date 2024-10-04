# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ------------------------------------------------------------------------------
variable "vpc_name" {
  description = <<-EOT
    (Required) The name of the VPC to apply the Firewall Policy to.

    ex:
    ```
    vpc_name = "anyscale-vpc"
    ```
  EOT
  type        = string
}

variable "vpc_id" {
  description = <<-EOT
    (Required) The ID or SelfLink of the VPC to apply the Firewall Policy to.

    ex:
    ```
    vpc_id = "projects/anyscale/global/networks/anyscale-network"
    ```
  EOT
  type        = string
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------
variable "module_enabled" {
  description = <<-EOT
    (Optional) Determines whether to create the resources inside this module.

    ex:
    ```
    module_enabled = true
    ```
  EOT
  type        = bool
  default     = true
}

variable "anyscale_project_id" {
  description = <<-EOT
    (Optional) The ID of the project to create the resource in.

    If it is not provided, the provider project is used.

    ex:
    ```
    anyscale_project_id = "project-1234567890"
    ```
  EOT
  type        = string
  default     = null
}

# --------------------------------------------------------------
# Firewall Policy
# --------------------------------------------------------------
variable "firewall_policy_name" {
  description = <<-EOT
    (Optional) The name of the firewall policy.

    If left `null`, the firewall name will default to the vpc name.

    ex:
    ```
    firewall_policy_name = "anyscale-vpc-firewall-policy"
    ```
  EOT
  type        = string
  default     = null
}


variable "firewall_policy_description" {
  description = <<-EOT
    (Optional) The description of the firewall policy.

    ex:
    ```
    firewall_policy_description = "Anyscale VPC Firewall Policy"
    ```
  EOT
  type        = string
  default     = "Anyscale VPC Firewall Policy"
}

#------------------------------------------------------------------------------
# Firewall Rules
#------------------------------------------------------------------------------
variable "enable_firewall_rule_logging" {
  description = <<-EOT
    (Optional) Determines whether to enable logging for firewall rules.

    ex:
    ```
    enable_firewall_rule_logging = true
    ```
  EOT
  type        = bool
  default     = true
}

variable "ingress_with_self_cidr_range" {
  description = <<-EOT
    (Optional) List of CIDR range to default to if a specific mapping isn't provided.

    ex:
    ```
    ingress_with_self_cidr_range = ["10.10.0.0/16","10.20.0.0/16"]
    ```
  EOT
  type        = list(string)
  default     = []
}

variable "ingress_with_self_map" {
  description = <<-EOT
    (Optional) List of ingress rules to create where 'self' is defined.

    Default rule is `all-all` as this firewall rule is used for all Anyscale resources.

    ex:
    ```
    ingress_with_self_map = [
      {
        rule        = "https-443-tcp"
      },
      {
        rule        = "http-80-tcp"
      },
      {
        rule        = "ssh-tcp"
      },
      {
        rule        = "nfs-tcp"
      }
    ]
    ```
  EOT
  type        = list(map(string))
  default     = [{ rule = "all-all" }]
}


variable "default_ingress_cidr_range" {
  description = <<-EOT
    (Optional) List of IPv4 cidr ranges to default to if a specific mapping isn't provided.

    ex:
    ```
    default_ingress_cidr_range = ["32.0.10.0/24","32.32.10.9/32"]
    ```
  EOT
  type        = list(string)
  default     = []
}

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
        ports       = "10,20,30"
        protocol    = "tcp"
        description = "Service name is TEST"
        cidr_blocks = "10.100.10.11/32"
      },
      {
        ports       = "82-84"
        protocol    = "tcp"
        description = "Service name is TEST"
        cidr_blocks = "10.100.10.12/32"
      }
    ]
    ```
    Default is an empty list.
  EOT
  type        = list(map(string))
  default     = []
}

variable "ingress_from_gcp_health_checks" {
  description = <<-EOT
    (Optional) List of ingress rules to create to allow GCP health check probes.

    This only uses rules from `predefined_firewall_rules`.
    More information on GCP health checks can be found here:
    https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges

    ex:
    ```
    ingress_from_gcp_health_checks = [
      {
        rule        = "health-checks"
        cidr_blocks = "35.191.0.0/16, 130.211.0.0/22"
      }
    ]
    ```
  EOT
  type        = list(map(string))
  default = [
    {
      rule        = "health-checks"
      cidr_blocks = "35.191.0.0/16,130.211.0.0/22"
    }
  ]
}

variable "ingress_from_machine_pool_cidr_ranges" {
  description = <<-EOT
    (Optional) List of CIDR ranges to allow ingress from machine pools.

    ex:
    ```
    ingress_from_machine_pool_cidr_ranges = ["10.100.10.0/24", "10.100.11.0/24"]
    ```
  EOT
  type        = list(string)
  default     = []
}

# --------------------
# Pre-defined rules
#   These are reuqired
# --------------------
variable "predefined_firewall_rules" {
  # tflint-ignore: terraform_standard_module_structure
  description = "(Required) Map of predefined firewall rules."
  type = map(object({
    ports       = string
    protocol    = string
    description = string
    priority    = number
  }))

  default = {
    all-all = {
      ports       = ""
      protocol    = "all"
      description = "All protocols"
      priority    = 1000
    }
    # HTTP
    http-80-tcp = {
      ports       = "80"
      protocol    = "tcp"
      description = "HTTP"
      priority    = 1001
    }
    # HTTPS
    https-443-tcp = {
      ports       = "443"
      protocol    = "tcp"
      description = "HTTPS"
      priority    = 1002
    }
    # SSH
    ssh-tcp = {
      ports       = "22"
      protocol    = "tcp"
      description = "SSH"
      priority    = 1003
    }
    # NFS
    nfs-tcp = {
      ports       = "2049"
      protocol    = "tcp"
      description = "NFS/EFS"
      priority    = 1004
    }
    # Health Checks
    health-checks = {
      ports       = "8000"
      protocol    = "tcp"
      description = "Health Checks"
      priority    = 1005
    }
    machine-pools = {
      ports       = "80,443,1010,1012,2222,5555,5903,6379,6822-6824,6826,7878,8000,8076,8085,8201,8265-8266,8686-8687,8912,8999,9090,9092,9100,9478-9482,10002-19999"
      protocol    = "tcp"
      description = "Machine Pools"
      priority    = 1011
    }
  }
}
