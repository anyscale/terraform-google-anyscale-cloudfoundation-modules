# ---------------------------------------------------------------------------------------------------------------------
# CREATE Anyscale Google VPC Resources
# This template creates VPC resources for Anyscale
# ---------------------------------------------------------------------------------------------------------------------
# locals {
#   full_labels = merge(tomap({
#     anyscale-cloud-id           = var.anyscale_cloud_id,
#     anyscale-deploy-environment = var.anyscale_deploy_env
#     }),
#     var.labels
#   )
# }

# ---------------------------------------------------------------------------------------------------------------------
# Create a VPC with minimal optional parameters
#   This does not create any subnets
# ---------------------------------------------------------------------------------------------------------------------
module "all_defaults" {
  source         = "../"
  module_enabled = true
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the minimum VPC needed for running Anyscale - Public Network
#   Specifying public subnet CIDRs
# ---------------------------------------------------------------------------------------------------------------------
module "minimum_anyscale_vpc_requirements_public" {
  source         = "../"
  module_enabled = true

  public_subnet_cidr       = "172.21.101.0/24"
  anyscale_vpc_name_prefix = "anyscale-tf-vpc-pub-"
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the minimum VPC needed for running Anyscale - Private Network
#   Specifying public subnet CIDRs
# ---------------------------------------------------------------------------------------------------------------------
module "minimum_anyscale_vpc_requirements_private" {
  source         = "../"
  module_enabled = true

  private_subnet_cidr      = "172.21.102.0/24"
  anyscale_vpc_name_prefix = "anyscale-tf-vpc-priv-"
}

# ---------------------------------------------------------------------------------------------------------------------
# Kitchen Sink
#   Use as many optional parameters as possible
# ---------------------------------------------------------------------------------------------------------------------
module "kitchen_sink" {
  source         = "../"
  module_enabled = true

  anyscale_project_id = var.google_project_id
  google_region       = var.google_region

  anyscale_vpc_name         = "anyscale-tf-ks-vpc"
  enable_random_name_suffix = false
  vpc_description           = "Anyscale VPC - Kitchen Sink Example"

  routing_mode = "GLOBAL"
  vpc_mtu      = 8896

  delete_default_internet_gateway_routes = true

  private_subnet_cidr   = "172.21.104.0/22"
  private_subnet_suffix = "subnet-private"
  private_subnet_flow_log_config = {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 1.0
    metadata             = "EXCLUDE_ALL_METADATA"
  }
  private_subnet_description = "Anyscale Subnet - Kitchen Sink Example - Private"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_enable_logging                 = true
  nat_log_config_filter              = "ERRORS_ONLY"
}

# ---------------------------------------------------------------------------------------------------------------------
# Do not create any resources
# ---------------------------------------------------------------------------------------------------------------------
module "test_no_resources" {
  source         = "../"
  module_enabled = false
}
