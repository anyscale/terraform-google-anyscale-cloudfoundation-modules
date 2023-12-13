# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ------------------------------------------------------------------------------
variable "memorystore_vpc_name" {
  description = <<-EOT
    (Required) VPC Name

    The name of the VPC to which the memorystore is attached.

    ex:
    ```
    memorystore_vpc_name = "anyscale-vpc"
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
  default     = false
}

variable "anyscale_project_id" {
  description = <<-EOT
    (Optional) Google Project ID

    ID of the project to create the resource in. If not provided, the provider project is used.

    ex:
    ```
    anyscale_project_id = "my-project"
    ```
  EOT
  type        = string
  default     = null
}

variable "google_region" {
  description = <<-EOT
    (Optional) Google Cloud Region

    The Google region in which all resources will be created. If not provided, the provider region is used.

    ex:
    ```
    google_region = "us-central1"
    ```
  EOT
  type        = string
  default     = null
}
variable "google_zone" {
  description = <<-EOT
    (Optional) Google Cloud Zone

    The Google zone in which resources will be created. If not provided, the service will choose two zones for the instances to be created in for protection against zonal failures.

    If `alternative_google_zone is also provided, it must be different from `google_zone`.

    ex:
    ```
    google_zone = "us-central1-a"
    ```
  EOT
  type        = string
  default     = null
}
variable "alternative_google_zone" {
  description = <<-EOT
    (Optional) Alternative Google Cloud Zone

    The alternative Google zone in which resources will be created.

    If `alternative_google_zone is also provided, it must be different from `google_zone`.
    If it is not provided, the service will choose two zones for the instances to be created in for protection against zonal failures.

    ex:
    ```
    alternative_google_zone = "us-central1-b"
    ```
  EOT
  type        = string
  default     = null
}

variable "labels" {
  description = <<-EOT
    (Optional) Google Cloud Labels

    A map of labels to add to all resources that accept labels.

    ex:
    ```
    labels = {
      "key1" = "value1"
      "key2" = "value2"
    }
    ```
  EOT
  type        = map(string)
  default     = {}
}

variable "enable_random_name_suffix" {
  description = <<-EOF
    (Optional) Determines if a suffix of random characters will be added to the Anyscale resources.

    ex:
    ```
    enable_random_name_suffix = true
    ```
  EOF
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
    random_char_length = 4
    ```
  EOT
  type        = number
  default     = 4
  validation {
    condition     = var.random_char_length % 2 == 0 || var.random_char_length < 4
    error_message = "`random_char_length` must be an even number and greater than or equal to 4."
  }
}

variable "anyscale_memorystore_name" {
  description = <<-EOT
    (Optional) The name of the memorystore to create.

    Conflicts with `anyscale_memorystore_name_prefix`.
    Must start with a lowercase letter followed by up to 62 lowercase letters, numbers, or hyphens, and cannot end with a hyphen.

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
    (Optional) The prefix of the memorystore to create.

    Conflicts `with anyscale_memorystore_name`.
    Must start with a lowercase letter followed by up to 48 lowercase letters, numbers, or hyphens.
    Because it is the prefix, it can end in a hyphen as it will have a random suffix appended to it.

    Default is `null` but set to `anyscale-memorystore-` in the module.

    ex:
    ```
    anyscale_memorystore_name_prefix = "anyscale-memorystore-"
    ```
  EOT
  type        = string
  default     = null
  validation {
    condition     = var.anyscale_memorystore_name_prefix == null ? true : can(regex("^(?:[a-z](?:[-a-z0-9]{0,47})?)$", var.anyscale_memorystore_name_prefix))
    error_message = "`anyscale_memorystore_name_prefix` must start with a lowercase letter followed by up to 48 lowercase letters, numbers, or hyphens."
  }
}

# ------------
# Memorystore Specific Variables
# ------------
variable "memorystore_tier" {
  description = <<-EOT
    (Optional) The service tier of the instance.

    Currently, only `STANDARD_HA` is supported.

    ex:
    ```
    memorystore_tier = "STANDARD_HA"
    ```
  EOT
  type        = string
  default     = "STANDARD_HA"
  validation {
    condition     = var.memorystore_tier == "STANDARD_HA"
    error_message = "`memorystore_tier` must be `STANDARD_HA`."
  }
}

variable "memorystore_replica_count" {
  description = <<-EOT
    (Optional) The number of replicas to be created in the cluster.

    Must be greater than or equal to 1 and less than or equal to 5.

    ex:
    ```
    memorystore_replica_count = 1
    ```
  EOT
  type        = number
  default     = 1
  validation {
    condition     = var.memorystore_replica_count > 0 || var.memorystore_replica_count <= 5
    error_message = "`memorystore_replica_count` must be greater than 1 and less than or equal to 5."
  }
}

variable "memorystore_replica_mode" {
  description = <<-EOT
    (Optional) The replication mode of the cluster.

    Currently, only `READ_REPLICAS_ENABLED` is supported.

    ex:
    ```
    memorystore_replica_mode = "READ_REPLICAS_ENABLED"
    ```
  EOT
  type        = string
  default     = "READ_REPLICAS_ENABLED"
  validation {
    condition     = var.memorystore_replica_mode == "READ_REPLICAS_ENABLED"
    error_message = "`memorystore_replica_mode` must be `READ_REPLICAS_ENABLED`."
  }
}

variable "memorystore_memory_size_gb" {
  description = <<-EOT
    (Optional) The memory size of the instance in GB.

    Must be greater than or equal to 5 and less than or equal to 300.

    ex:
    ```
    memorystore_memory_size_gb = 5
    ```
  EOT
  type        = number
  default     = 5
  validation {
    condition     = var.memorystore_memory_size_gb >= 5 || var.memorystore_memory_size_gb <= 300
    error_message = "`memorystore_memory_size_gb` must be greater than or equal to 5 and less than or equal to 300."
  }
}

variable "memorystore_connect_mode" {
  description = <<-EOT
    (Optional) The connection mode of the instance.

    Must be one of `DIRECT_PEERING` or `PRIVATE_SERVICE_ACCESS`.

    ex:
    ```
    memorystore_connect_mode = "DIRECT_PEERING"
    ```
  EOT
  type        = string
  default     = "DIRECT_PEERING"
  validation {
    condition     = contains(["DIRECT_PEERING", "PRIVATE_SERVICE_ACCESS"], var.memorystore_connect_mode)
    error_message = "`memorystore_connect_mode` must be one of `DIRECT_PEERING` or `PRIVATE_SERVICE_ACCESS`."
  }
}

variable "memorystore_redis_version" {
  description = <<-EOT
    (Optional) The version of Redis software.

    Must be one of `REDIS_5_0`, `REDIS_6_X`, or `REDIS_7_0`.

    ex:
    ```
    memorystore_redis_version = "REDIS_6_X"
    ```
  EOT
  type        = string
  default     = "REDIS_7_0"
  validation {
    condition     = contains(["REDIS_5_0", "REDIS_6_X", "REDIS_7_0"], var.memorystore_redis_version)
    error_message = "`memorystore_redis_version` must be one of `REDIS_5_0`, `REDIS_6_X`, or `REDIS_7_0`."
  }
}

variable "memorystore_redis_configs" {
  description = <<-EOT
    (Optional) The Redis configuration parameters.

    ex:
    ```
    memorystore_redis_configs = {
      "maxmemory-policy" = "allkeys-lru"
    }
    ```
  EOT
  type        = map(string)
  default = {
    "maxmemory-policy" = "allkeys-lru"
  }
}

variable "memorystore_display_name" {
  description = <<-EOT
    (Optional) The display name of the memorystore.

    ex:
    ```
    memorystore_display_name = "Anyscale Memorystore"
    ```
  EOT
  type        = string
  default     = null
}

variable "memorystore_enable_auth" {
  description = <<-EOT
    (Optional) Determines if User Auth is enabled for the instance.

    If set to true Auth is enabled on the instance.

    ex:
    ```
    enable_user_auth = true
    ```
  EOT
  type        = bool
  default     = false
}

variable "memorystore_encryption_mode" {
  description = <<-EOT
    (Optional) The TLS mode of the Redis instance.

    If not provided, TLS is enabled for the instance. Valid values are `SERVER_AUTHENTICATION` or `DISABLED`.

    ex:
    ```
    transit_encryption_mode = "SERVER_AUTHENTICATION"
    ```
  EOT
  type        = string
  default     = "DISABLED"
  validation {
    condition     = contains(["SERVER_AUTHENTICATION", "DISABLED"], var.memorystore_encryption_mode)
    error_message = "`transit_encryption_mode` must be one of `SERVER_AUTHENTICATION` or `DISABLED`."
  }
}

variable "memorystore_maintenance_policy" {
  description = <<-EOT
    (Optional) The maintenance policy for an instance.

    ex:
    ```
    memorystore_maintenance_policy = {
      day = "MONDAY"
      start_time = {
        hours   = 3
        minutes = 30
        seconds = 0
        nanos   = 0
      }
    }
    ```
  EOT
  type = object({
    day = string
    start_time = object({
      hours   = number
      minutes = number
      seconds = number
      nanos   = number
    })
  })
  default = null
}

variable "memorystore_persistence_config" {
  description = <<-EOT
    (Optional) The persistence configuration for an instance.

    ex:
    ```
    memorystore_persistence_config = {
      persistence_mode    = "RDB"
      rdb_snapshot_period = "TWENTY_FOUR_HOURS"
    }
    ```
  EOT
  type = object({
    persistence_mode    = string
    rdb_snapshot_period = string
  })
  default = null
  validation {
    condition     = var.memorystore_persistence_config == null ? true : contains(["RDB", "DISABLED"], var.memorystore_persistence_config["persistence_mode"])
    error_message = "`persistence_mode` must be empty or one of `RDB` or `DISABLED`."
  }
  validation {
    condition     = var.memorystore_persistence_config == null ? true : contains(["ONE_HOUR", "SIX_HOURS", "TWELVE_HOURS", "TWENTY_FOUR_HOURS"], var.memorystore_persistence_config["rdb_snapshot_period"])
    error_message = "`rdb_snapshot_period` must be empty or one of `ONE_HOUR`, `SIX_HOURS`, `TWELVE_HOURS`, or `TWENTY_FOUR_HOURS`."
  }
}
