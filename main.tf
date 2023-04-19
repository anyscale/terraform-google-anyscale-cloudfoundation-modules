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
}
module "google_anyscale_cloudapis" {
  source         = "./modules/google-anyscale-cloudapis"
  module_enabled = local.execute_api_submodule

  anyscale_project_id = coalesce(var.existing_project_id, module.google_anyscale_project.project_id)
}

# ------------------------------
# VPC (Networking) Module
# ------------------------------
locals {
  vpc_name        = var.anyscale_vpc_name != null ? var.anyscale_vpc_name : local.common_name
  vpc_name_prefix = coalesce(var.anyscale_vpc_name_prefix, var.common_prefix, "anyscale-vpc-")

  anyscale_private_subnet_count = var.anyscale_vpc_private_subnet_cidr != null ? 1 : 0
  anyscale_public_subnet_count  = var.anyscale_vpc_public_subnet_cidr != null ? 1 : 0

  create_new_vpc         = var.existing_vpc_name == null ? true : false
  create_vpc_subnets     = local.anyscale_private_subnet_count > 0 || local.anyscale_public_subnet_count > 0 ? true : false
  create_nat_gw          = local.create_new_vpc && var.anyscale_vpc_create_natgw && local.anyscale_private_subnet_count > 0 ? true : false
  execute_vpc_sub_module = local.create_new_vpc || local.create_vpc_subnets ? true : false
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

  public_subnet_cidr  = var.anyscale_vpc_public_subnet_cidr
  private_subnet_cidr = var.anyscale_vpc_private_subnet_cidr

  create_nat = local.create_nat_gw
}

# ------------------------------
# AnyScale VPC Firewall Module
# ------------------------------
locals {
  execute_vpc_firewall_sub_module = local.create_new_vpc || var.enable_anyscale_vpc_firewall ? true : false

  google_ui_cidr          = "35.235.240.0/20"
  allow_access_from_cidrs = "${var.anyscale_vpc_firewall_allow_access_from_cidrs}${var.allow_ssh_from_google_ui ? ",${local.google_ui_cidr}" : ""}"

  ingress_from_cidr_map = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = local.allow_access_from_cidrs
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = local.allow_access_from_cidrs
    }
  ]

  ingress_from_self_cidr_range = compact(
    [
      var.anyscale_vpc_public_subnet_cidr,
      var.anyscale_vpc_private_subnet_cidr,
      try(data.google_compute_subnetwork.existing_vpc_subnet[0].ip_cidr_range, null)
    ]
  )
}
module "google_anyscale_vpc_firewall_policy" {
  source         = "./modules/google-anyscale-vpc-firewall"
  module_enabled = local.execute_vpc_firewall_sub_module
  depends_on = [
    module.google_anyscale_cloudapis
  ]
  anyscale_project_id = coalesce(var.existing_project_id, module.google_anyscale_project.project_id)

  vpc_name = coalesce(var.existing_vpc_name, module.google_anyscale_vpc.vpc_name)

  firewall_policy_name        = var.anyscale_vpc_firewall_policy_name
  firewall_policy_description = var.anyscale_vpc_firewall_policy_description

  ingress_from_cidr_map        = local.ingress_from_cidr_map
  ingress_with_self_cidr_range = local.ingress_from_self_cidr_range
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

  filestore_vpc_name = coalesce(var.existing_vpc_name, module.google_anyscale_vpc.vpc_name)
  filestore_location = coalesce(var.anyscale_filestore_location, module.google_anyscale_vpc.private_subnet_region, module.google_anyscale_vpc.public_subnet_region, data.google_client_config.current.region)
}
module "google_anyscale_filestore" {
  source         = "./modules/google-anyscale-filestore"
  module_enabled = local.execute_filestore_submodule
  depends_on = [
    module.google_anyscale_cloudapis
  ]
  anyscale_project_id = coalesce(var.existing_project_id, module.google_anyscale_project.project_id)

  enable_random_name_suffix = local.enable_module_random_name_suffix

  anyscale_filestore_name        = local.filestore_name
  anyscale_filestore_name_prefix = local.filestore_prefix

  anyscale_filestore_fileshare_name        = local.fileshare_name
  anyscale_filestore_fileshare_capacity_gb = var.anyscale_filestore_capacity_gb

  filestore_description = var.anyscale_filestore_description
  filestore_location    = local.filestore_location
  filestore_vpc_name    = local.filestore_vpc_name
  filestore_tier        = var.anyscale_filestore_tier
  labels                = local.full_labels
}

# ------------------------------
# Google IAM Module
# ------------------------------
locals {
  execute_iam_submodule = var.enable_anyscale_iam ? true : false

  iam_access_role_name        = var.anyscale_iam_access_role_name != null ? var.anyscale_iam_access_role_name : local.common_name != null ? "${local.common_name}-access" : null
  iam_access_role_name_prefix = coalesce(var.anyscale_iam_access_role_name_prefix, var.common_prefix, "anyscale-crossacct-")

  iam_cluster_node_role_name        = var.anyscale_cluster_node_role_name != null ? var.anyscale_cluster_node_role_name : local.common_name != null ? "${local.common_name}-cluster" : null
  iam_cluster_node_role_name_prefix = coalesce(var.anyscale_cluster_node_role_name_prefix, var.common_prefix, "anyscale-cluster-")
}
module "google_anyscale_iam" {
  source              = "./modules/google-anyscale-iam"
  module_enabled      = local.execute_iam_submodule
  anyscale_project_id = coalesce(var.existing_project_id, module.google_anyscale_project.project_id)

  enable_random_name_suffix = local.enable_module_random_name_suffix

  anyscale_access_role_name        = local.iam_access_role_name
  anyscale_access_role_name_prefix = local.iam_access_role_name_prefix
  anyscale_access_role_description = var.anyscale_iam_access_role_description

  workload_identity_pool_name          = var.anyscale_workload_identity_pool_name
  workload_identity_pool_display_name  = var.anyscale_workload_identity_pool_display_name
  workload_identity_pool_description   = var.anyscale_workload_identity_pool_description
  workload_identity_pool_provider_name = var.anyscale_workload_identity_pool_provider_name
  workload_anyscale_aws_account_id     = var.anyscale_workload_identity_account_id

  anyscale_cluster_node_role_name        = local.iam_cluster_node_role_name
  anyscale_cluster_node_role_name_prefix = local.iam_cluster_node_role_name_prefix
  anyscale_cluster_node_role_description = var.anyscale_cluster_node_role_description

  anyscale_cloud_id = var.anyscale_cloud_id
}

# ------------------------------
# Google Cloud Storage Module
# ------------------------------
locals {
  execute_gcs_submodule = var.enable_anyscale_gcs && var.existing_cloudstorage_bucket_name == null ? true : false

  bucket_name   = var.anyscale_bucket_name != null ? var.anyscale_bucket_name : local.common_name
  bucket_prefix = coalesce(var.anyscale_bucket_prefix, var.common_prefix, "anyscale-")

  bucket_iam_binding_members = local.execute_iam_submodule ? ["serviceAccount:${module.google_anyscale_iam.iam_anyscale_access_role_email}", "serviceAccount:${module.google_anyscale_iam.iam_anyscale_cluster_node_role_email}"] : []
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

  bucket_iam_binding_members        = local.bucket_iam_binding_members
  bucket_iam_binding_override_roles = var.bucket_iam_binding_override_roles
}
