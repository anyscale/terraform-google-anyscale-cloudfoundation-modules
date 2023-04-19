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
module "filestore_cloudapis" {
  source         = "../../google-anyscale-cloudapis"
  module_enabled = true
}
module "filestore_vpc" {
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

  filestore_vpc_name = module.filestore_vpc.vpc_name
  depends_on = [
    module.filestore_cloudapis
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

  anyscale_filestore_name = "anyscale-filestore-kitchen-sink"
  filestore_description   = "Anyscale FileStore Kitchen Sink"
  filestore_tier          = "STANDARD"
  filestore_location      = "us-central1-b"

  anyscale_filestore_fileshare_name        = "anys_kitchensink"
  anyscale_filestore_fileshare_capacity_gb = 1024

  filestore_vpc_name            = module.filestore_vpc.vpc_name
  filestore_network_modes       = ["MODE_IPV4", "ADDRESS_MODE_UNSPECIFIED"]
  filestore_network_conect_mode = "PRIVATE_SERVICE_ACCESS"

  depends_on = [
    module.filestore_cloudapis
  ]

  labels = local.full_labels
}


# ---------------------------------------------------------------------------------------------------------------------
# test_no_resources
#   Do not create any resources
# ---------------------------------------------------------------------------------------------------------------------
module "test_no_resources" {
  source = "../"

  module_enabled      = false
  anyscale_project_id = var.google_project_id

  filestore_vpc_name = null
}
