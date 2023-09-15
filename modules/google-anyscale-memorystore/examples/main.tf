# ---------------------------------------------------------------------------------------------------------------------
# CREATE Anyscale Google VPC Resources
# This template creates VPC resources for Anyscale
# ---------------------------------------------------------------------------------------------------------------------
locals {
  full_labels = merge(tomap({
    anyscale-cloud-id           = var.anyscale_cloud_id,
    anyscale-deploy-environment = var.anyscale_deploy_env
    }),
    var.labels
  )
}
# We need APIs and a VPC for all resources below - no need to create a separate module for this
module "memorystore_cloudapis" {
  source         = "../../google-anyscale-cloudapis"
  module_enabled = true
  anyscale_activate_optional_apis = [
    "redis.googleapis.com"
  ]
}
module "memorystore_vpc" {
  source         = "../../google-anyscale-vpc"
  module_enabled = true

  public_subnet_cidr = "172.21.101.0/24"
}

# ---------------------------------------------------------------------------------------------------------------------
# all_defaults
#   Create a FileStore with all defaults
#   Includes creating a VPC
# ---------------------------------------------------------------------------------------------------------------------
module "all_defaults" {
  source         = "../"
  module_enabled = true

  memorystore_vpc_name = module.memorystore_vpc.vpc_name
  depends_on = [
    module.memorystore_cloudapis
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# kitchen_sink
#   Create all resources with all optional parameters
# ---------------------------------------------------------------------------------------------------------------------
module "kitchen_sink" {
  source                    = "../"
  module_enabled            = true
  enable_random_name_suffix = false

  anyscale_memorystore_name   = "anyscale-memorystore-kitchen-sink"
  memorystore_display_name    = "Kitchen Sink Display Name"
  memorystore_tier            = "STANDARD_HA"
  memorystore_replica_count   = 3
  memorystore_redis_version   = "REDIS_7_0"
  memorystore_replica_mode    = "READ_REPLICAS_ENABLED"
  memorystore_memory_size_gb  = 10
  memorystore_connect_mode    = "DIRECT_PEERING"
  memorystore_encryption_mode = "SERVER_AUTHENTICATION"

  google_zone             = "us-central1-b"
  alternative_google_zone = "us-central1-c"

  memorystore_maintenance_policy = {
    day = "MONDAY"
    start_time = {
      hours   = 3
      minutes = 30
      seconds = 0
      nanos   = 0
    }
  }
  memorystore_persistence_config = {
    persistence_mode    = "RDB"
    rdb_snapshot_period = "TWENTY_FOUR_HOURS"
  }

  memorystore_vpc_name = module.memorystore_vpc.vpc_name

  memorystore_redis_configs = {
    "maxmemory-policy" = "allkeys-random"
  }

  labels = merge(tomap(
    {
      kitchen_sink = "true"
    }),
    local.full_labels
  )

  depends_on = [
    module.memorystore_cloudapis
  ]
}


# ---------------------------------------------------------------------------------------------------------------------
# test_no_resources
#   Do not create any resources
# ---------------------------------------------------------------------------------------------------------------------
module "test_no_resources" {
  source = "../"

  module_enabled      = false
  anyscale_project_id = var.google_project_id

  memorystore_vpc_name = null
}
