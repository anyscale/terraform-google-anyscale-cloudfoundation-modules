locals {
  full_labels = merge(tomap({
    anyscale-cloud-id           = var.anyscale_cloud_id,
    anyscale-deploy-environment = var.anyscale_deploy_env
    tf_module                   = "google-anyscale-cloudfoundations"
    }),
    var.labels
  )

  random_char_length = var.random_char_length >= 4 && var.random_char_length % 2 == 0 ? var.random_char_length / 2 : 0

  common_name_prefix               = var.use_common_name ? coalesce(var.common_prefix, "anyscale-") : null
  enable_module_random_name_suffix = var.use_common_name ? false : true
  enable_root_random_name_suffix   = var.use_common_name ? true : false

  enable_cloud_logging_monitoring = var.enable_cloud_logging_monitoring ? true : false
}

# ------------------------------
# Common Name Random ID
# ------------------------------
resource "random_id" "common_name" {
  count = local.enable_root_random_name_suffix ? 1 : 0

  byte_length = local.random_char_length
  prefix      = local.common_name_prefix
}
locals {
  common_name = try(random_id.common_name[0].hex, null)
}

# ------------------------------
# Google Project Module
# ------------------------------
locals {
  create_new_project  = var.existing_project_id == null ? true : false
  project_name        = var.anyscale_project_name != null ? var.anyscale_project_name : local.common_name
  project_name_prefix = coalesce(var.anyscale_project_name_prefix, var.common_prefix, "anyscale-project-")

  project_labels = merge(local.full_labels, var.anyscale_project_labels)

  execute_project_submodule = local.create_new_project ? true : false
}
module "google_anyscale_project" {
  source         = "./modules/google-anyscale-project"
  module_enabled = local.execute_project_submodule

  anyscale_project_name        = local.project_name
  anyscale_project_name_prefix = local.project_name_prefix
  enable_random_name_suffix    = local.enable_module_random_name_suffix

  folder_id          = var.anyscale_project_folder_id
  organization_id    = var.anyscale_project_organization_id
  billing_account_id = var.anyscale_project_billing_account

  labels = local.project_labels
}

# ------------------------------
# Google API Module
# ------------------------------
locals {
  execute_api_submodule = var.enable_google_apis ? true : false

  memorystore_api = local.execute_memorystore_submodule ? ["redis.googleapis.com"] : []
  monitoring_api  = local.enable_cloud_logging_monitoring ? ["monitoring.googleapis.com", "logging.googleapis.com"] : []

  additional_apis = concat(local.memorystore_api, local.monitoring_api)
}
module "google_anyscale_cloudapis" {
  source         = "./modules/google-anyscale-cloudapis"
  module_enabled = local.execute_api_submodule

  anyscale_project_id = coalesce(var.existing_project_id, module.google_anyscale_project.project_id)

  anyscale_activate_optional_apis = local.additional_apis
}

# ------------------------------
# VPC (Networking) Module
# ------------------------------
locals {
  google_region = data.google_client_config.current.region

  vpc_name        = var.anyscale_vpc_name != null ? var.anyscale_vpc_name : var.anyscale_vpc_name_prefix != null ? null : local.common_name
  vpc_name_prefix = coalesce(var.anyscale_vpc_name_prefix, var.common_prefix, "anyscale-vpc-")

  public_subnet_name  = coalesce(var.anyscale_vpc_public_subnet_name, try("${local.vpc_name}-${local.google_region}-${var.anyscale_vpc_public_subnet_suffix}", null), "anyscale-vpc-subnet-public")
  private_subnet_name = coalesce(var.anyscale_vpc_private_subnet_name, try("${local.vpc_name}-${local.google_region}-${var.anyscale_vpc_private_subnet_suffix}", null), "anyscale-vpc-subnet-private")
  proxy_subnet_name   = coalesce(var.anyscale_vpc_proxy_subnet_name, try("${local.vpc_name}-${local.google_region}-${var.anyscale_vpc_proxy_subnet_suffix}", null), "anyscale-vpc-subnet-proxy")

  anyscale_private_subnet_count = var.anyscale_vpc_private_subnet_cidr != null ? 1 : 0
  # anyscale_proxy_subnet_count   = var.anyscale_vpc_proxy_subnet_cidr != null ? 1 : 0
  # anyscale_public_subnet_count = var.anyscale_vpc_public_subnet_cidr != null ? 1 : 0

  create_new_vpc = var.existing_vpc_name == null && var.existing_vpc_id == null ? true : false
  # create_vpc_subnets = local.anyscale_proxy_subnet_count > 0 || local.anyscale_private_subnet_count > 0 || local.anyscale_public_subnet_count > 0 ? true : false
  create_nat_gw = local.create_new_vpc && var.anyscale_vpc_create_natgw && local.anyscale_private_subnet_count > 0 ? true : false
  # Execute VPC module only when creating a new VPC
  # If existing_vpc_name or existing_vpc_id is provided, existing_vpc_subnet_name is also required
  # and we don't create any new VPC resources
  execute_vpc_sub_module = local.create_new_vpc ? true : false
}
module "google_anyscale_vpc" {
  source         = "./modules/google-anyscale-vpc"
  module_enabled = local.execute_vpc_sub_module
  depends_on = [
    module.google_anyscale_cloudapis
  ]
  anyscale_project_id = coalesce(var.existing_project_id, module.google_anyscale_project.project_id)

  anyscale_vpc_name         = local.vpc_name
  anyscale_vpc_name_prefix  = local.vpc_name_prefix
  enable_random_name_suffix = local.enable_module_random_name_suffix
  vpc_description           = var.anyscale_vpc_description

  public_subnet_cidr = var.anyscale_vpc_public_subnet_cidr
  public_subnet_name = local.public_subnet_name

  private_subnet_cidr = var.anyscale_vpc_private_subnet_cidr
  private_subnet_name = local.private_subnet_name

  proxy_subnet_cidr = var.anyscale_vpc_proxy_subnet_cidr
  proxy_subnet_name = local.proxy_subnet_name

  create_nat = local.create_nat_gw
}

# ------------------------------
# AnyScale VPC Firewall Module
# ------------------------------
locals {
  execute_vpc_firewall_sub_module = var.enable_anyscale_vpc_firewall ? true : false

  firewall_policy_name = coalesce(var.anyscale_vpc_firewall_policy_name, var.existing_vpc_name, var.anyscale_vpc_name, local.common_name, "anyscale-firewall-policy")

  vpc_project_id = coalesce(var.shared_vpc_project_id, var.existing_project_id, module.google_anyscale_project.project_id)

  google_ui_cidr = "35.235.240.0/20"
  allow_access_from_cidrs = join(",", compact([
    var.anyscale_vpc_firewall_allow_access_from_cidrs,
    var.anyscale_vpc_proxy_subnet_cidr != null ? var.anyscale_vpc_proxy_subnet_cidr : null,
    var.allow_ssh_from_google_ui ? local.google_ui_cidr : null
  ]))

  ingress_from_cidr_map = concat([
    {
      rule        = "https-443-tcp"
      cidr_blocks = local.allow_access_from_cidrs
    }
    ], var.security_group_enable_ssh_access ? [
    {
      rule        = "ssh-tcp"
      cidr_blocks = local.allow_access_from_cidrs
    }
  ] : [])

  ingress_from_self_cidr_range = compact(
    [
      var.anyscale_vpc_public_subnet_cidr,
      var.anyscale_vpc_private_subnet_cidr,
      try(data.google_compute_subnetwork.existing_vpc_subnet[0].ip_cidr_range, null),
      try(data.google_compute_subnetwork.shared_vpc_subnet[0].ip_cidr_range, null)
    ]
  )

  ingress_from_gcp_health_checks = [
    {
      rule = "health-checks"
      cidr_blocks = join(",", compact([
        var.anyscale_vpc_proxy_subnet_cidr, # Needs to include the Proxy Subnet to actually send traffic to the health check endpoint
        "35.191.0.0/16",                    # GCP Health Check IP Range
        "130.211.0.0/22"                    # GCP Health Check IP Range
      ]))
    }
  ]
}

module "google_anyscale_vpc_firewall_policy" {
  source         = "./modules/google-anyscale-vpc-firewall"
  module_enabled = local.execute_vpc_firewall_sub_module
  depends_on = [
    module.google_anyscale_cloudapis,
    module.google_anyscale_vpc
  ]
  anyscale_project_id = local.vpc_project_id

  vpc_name = local.execute_vpc_firewall_sub_module ? coalesce(var.existing_vpc_name, module.google_anyscale_vpc.vpc_name) : ""
  vpc_id   = local.execute_vpc_firewall_sub_module ? coalesce(var.existing_vpc_id, module.google_anyscale_vpc.vpc_id) : ""

  firewall_policy_name        = local.firewall_policy_name
  firewall_policy_description = var.anyscale_vpc_firewall_policy_description

  ingress_from_cidr_map        = local.ingress_from_cidr_map
  ingress_with_self_cidr_range = local.ingress_from_self_cidr_range

  ingress_from_gcp_health_checks = local.ingress_from_gcp_health_checks

  ingress_from_machine_pool_cidr_ranges = var.ingress_from_machine_pool_cidr_ranges
}

# ------------------------------
# Google Filestore Module
# ------------------------------
locals {
  execute_filestore_submodule = var.enable_anyscale_filestore && var.existing_filestore_instance_name == null ? true : false

  filestore_name   = var.anyscale_filestore_name != null ? var.anyscale_filestore_name : try(replace(local.common_name, "_", "-"), null)
  filestore_prefix = coalesce(var.anyscale_filestore_name_prefix, try(replace(var.common_prefix, "_", "-"), null), "anyscale-")

  # Changed the following because Basic and Standard filestores limit the fileshare name to 16 characters
  fileshare_common_name = local.common_name != null ? length(local.common_name) <= 16 ? replace(local.common_name, "-", "_") : "anyscale" : "anyscale"
  fileshare_name        = coalesce(var.anyscale_filestore_fileshare_name, local.fileshare_common_name)
  # fileshare_name_prefix = coalesce(var.anyscale_filestore_fileshare_name_prefix, try(replace(var.common_prefix, "-", "_"), null), "anyscale_")

  filestore_shared_vpc = var.shared_vpc_project_id != null && var.existing_vpc_name != null ? "projects/${var.shared_vpc_project_id}/global/networks/${var.existing_vpc_name}" : null
  filestore_vpc_name   = coalesce(local.filestore_shared_vpc, var.existing_vpc_name, module.google_anyscale_vpc.vpc_name)

  # Using the following to determine a default zone for the filestore instance if not ENTERPRISE tier.
  # This matches `anyscale cloud setup` logic - setting default to -b zones
  filestore_private_subnet_zone = module.google_anyscale_vpc.private_subnet_region != "" ? "${module.google_anyscale_vpc.private_subnet_region}-b" : null
  filestore_public_subnet_zone  = module.google_anyscale_vpc.public_subnet_region != "" ? "${module.google_anyscale_vpc.public_subnet_region}-b" : null

  filestore_location_zone   = coalesce(var.anyscale_filestore_location, local.filestore_private_subnet_zone, local.filestore_public_subnet_zone, data.google_client_config.current.zone)
  filestore_location_region = coalesce(var.anyscale_filestore_location, module.google_anyscale_vpc.private_subnet_region, module.google_anyscale_vpc.public_subnet_region, data.google_client_config.current.region)
  filestore_location        = var.anyscale_filestore_tier == "ENTERPRISE" ? local.filestore_location_region : local.filestore_location_zone

}
module "google_anyscale_filestore" {
  source              = "./modules/google-anyscale-filestore"
  module_enabled      = local.execute_filestore_submodule
  labels              = merge(local.full_labels, var.anyscale_filestore_labels)
  anyscale_project_id = coalesce(var.existing_project_id, module.google_anyscale_project.project_id)
  depends_on = [
    module.google_anyscale_cloudapis
  ]

  enable_random_name_suffix = local.enable_module_random_name_suffix

  anyscale_filestore_name        = local.filestore_name
  anyscale_filestore_name_prefix = local.filestore_prefix

  anyscale_filestore_fileshare_name        = local.fileshare_name
  anyscale_filestore_fileshare_capacity_gb = var.anyscale_filestore_capacity_gb

  filestore_description = var.anyscale_filestore_description
  filestore_location    = local.filestore_location
  filestore_tier        = var.anyscale_filestore_tier

  filestore_vpc_name            = local.filestore_vpc_name
  filestore_network_conect_mode = var.anyscale_filestore_network_conect_mode
}

# ------------------------------
# Google IAM Module
# ------------------------------
locals {
  execute_iam_submodule = var.enable_anyscale_iam ? true : false

  iam_access_service_acct_name        = var.anyscale_iam_access_service_acct_name != null ? var.anyscale_iam_access_service_acct_name : local.common_name != null ? "${local.common_name}-access" : null
  iam_access_service_acct_name_prefix = coalesce(var.anyscale_iam_access_service_acct_name_prefix, var.common_prefix, "anyscale-crossacct-")

  common_name_underscores   = try(replace(local.common_name, "-", "_"), null)
  common_prefix_underscores = try(replace(var.common_prefix, "-", "_"), null)

  iam_access_role_id        = var.anyscale_iam_access_role_id != null ? var.anyscale_iam_access_role_id : local.common_name_underscores != null ? "${local.common_name_underscores}_access" : null
  iam_access_role_id_prefix = coalesce(var.anyscale_iam_access_role_id_prefix, local.common_prefix_underscores, "anyscale_crossacct_")

  iam_cluster_node_service_acct_name        = var.anyscale_cluster_node_service_acct_name != null ? var.anyscale_cluster_node_service_acct_name : local.common_name != null ? "${local.common_name}-cluster" : null
  iam_cluster_node_service_acct_name_prefix = coalesce(var.anyscale_cluster_node_service_acct_name_prefix, var.common_prefix, "anyscale-cluster-")
}
module "google_anyscale_iam" {
  source         = "./modules/google-anyscale-iam"
  module_enabled = local.execute_iam_submodule

  anyscale_project_id = coalesce(var.existing_project_id, module.google_anyscale_project.project_id)
  anyscale_org_id     = var.anyscale_organization_id

  enable_random_name_suffix = local.enable_module_random_name_suffix

  anyscale_access_service_acct_name        = local.iam_access_service_acct_name
  anyscale_access_service_acct_name_prefix = local.iam_access_service_acct_name_prefix
  anyscale_access_service_acct_description = var.anyscale_iam_access_service_acct_description

  anyscale_access_role_id          = local.iam_access_role_id
  anyscale_access_role_id_prefix   = local.iam_access_role_id_prefix
  anyscale_access_role_description = var.anyscale_access_role_description

  existing_workload_identity_provider_name = var.existing_workload_identity_provider_name
  workload_identity_pool_name              = var.anyscale_workload_identity_pool_name
  workload_identity_pool_display_name      = var.anyscale_workload_identity_pool_display_name
  workload_identity_pool_description       = var.anyscale_workload_identity_pool_description
  workload_identity_pool_provider_name     = var.anyscale_workload_identity_pool_provider_name
  workload_anyscale_aws_account_id         = var.anyscale_workload_identity_account_id

  anyscale_cluster_node_service_acct_name        = local.iam_cluster_node_service_acct_name
  anyscale_cluster_node_service_acct_name_prefix = local.iam_cluster_node_service_acct_name_prefix
  anyscale_cluster_node_service_acct_description = var.anyscale_cluster_node_service_acct_description
  enable_anyscale_cluster_logging_monitoring     = local.enable_cloud_logging_monitoring

  anyscale_cloud_id = var.anyscale_cloud_id
}

# ------------------------------
# Google Cloud Storage Module
# ------------------------------
locals {
  execute_gcs_submodule = var.enable_anyscale_gcs && var.existing_cloudstorage_bucket_name == null ? true : false

  bucket_name   = var.anyscale_bucket_name != null ? var.anyscale_bucket_name : local.common_name
  bucket_prefix = coalesce(var.anyscale_bucket_prefix, var.common_prefix, "anyscale-")

  bucket_iam_members = local.execute_iam_submodule ? [
    module.google_anyscale_iam.iam_anyscale_access_service_acct_member,
    module.google_anyscale_iam.iam_anyscale_cluster_node_service_acct_member
  ] : []
}
module "google_anyscale_cloudstorage" {
  source         = "./modules/google-anyscale-cloudstorage"
  module_enabled = local.execute_gcs_submodule
  depends_on = [
    module.google_anyscale_cloudapis
  ]
  labels              = local.full_labels
  anyscale_project_id = coalesce(var.existing_project_id, module.google_anyscale_project.project_id)

  anyscale_bucket_name        = local.bucket_name
  anyscale_bucket_name_prefix = local.bucket_prefix
  enable_random_name_suffix   = local.enable_module_random_name_suffix

  bucket_location      = var.anyscale_bucket_location
  bucket_storage_class = var.anyscale_bucket_storage_class
  lifecycle_rules      = var.anyscale_bucket_lifecycle_rules
  cors_rules           = var.anyscale_bucket_cors_rules

  bucket_iam_members                 = local.bucket_iam_members
  bucket_iam_member_additional_roles = var.bucket_iam_member_additional_roles
}

# ------------------------------
# Google Memorystore Module
# ------------------------------
locals {
  execute_memorystore_submodule = var.enable_anyscale_memorystore && var.existing_memorystore_instance_name == null ? true : false
  memorystore_vpc_name          = coalesce(var.existing_vpc_name, module.google_anyscale_vpc.vpc_name)

  memorystore_name   = var.anyscale_memorystore_name != null ? var.anyscale_memorystore_name : var.anyscale_memorystore_name_prefix != null ? null : try(replace(local.common_name, "_", "-"), null)
  memorystore_prefix = coalesce(var.anyscale_memorystore_name_prefix, try(replace(var.common_prefix, "_", "-"), null), "anyscale-")
}
module "google_anyscale_memorystore" {
  source              = "./modules/google-anyscale-memorystore"
  module_enabled      = local.execute_memorystore_submodule
  labels              = merge(local.full_labels, var.anyscale_memorystore_labels)
  anyscale_project_id = coalesce(var.existing_project_id, module.google_anyscale_project.project_id)
  depends_on = [
    module.google_anyscale_cloudapis
  ]

  enable_random_name_suffix = local.enable_module_random_name_suffix

  anyscale_memorystore_name        = local.memorystore_name
  anyscale_memorystore_name_prefix = local.memorystore_prefix
  memorystore_display_name         = var.anyscale_memorystore_display_name

  memorystore_vpc_name = local.memorystore_vpc_name
}

# ------------------------------
# Google LoggingSink Module
# ------------------------------
locals {
  execute_loggingsink_submodule = var.enable_anyscale_loggingsink ? true : false
}
module "google_anyscale_loggingsink" {
  source              = "./modules/google-anyscale-loggingsink"
  module_enabled      = local.execute_loggingsink_submodule
  anyscale_project_id = coalesce(var.existing_project_id, module.google_anyscale_project.project_id)
  depends_on = [
    module.google_anyscale_cloudapis
  ]
}
