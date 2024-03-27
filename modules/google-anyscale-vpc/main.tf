locals {
  random_char_length = var.random_char_length >= 4 && var.random_char_length % 2 == 0 ? var.random_char_length / 2 : 0
  google_region      = coalesce(var.google_region, data.google_client_config.current.region)

  anyscale_vpcname          = var.anyscale_vpc_name != null ? var.anyscale_vpc_name : var.anyscale_vpc_name_prefix
  computed_anyscale_vpcname = var.enable_random_name_suffix ? "${local.anyscale_vpcname}${random_id.random_char_suffix.hex}" : local.anyscale_vpcname

  # module_labels = merge(
  #   tomap({
  #     tf_sub_module = "google-anyscale-vpc"
  #   }),
  # var.labels)
}

#-------------------------------
# Random Strings for VPC Name
#-------------------------------
resource "random_id" "random_char_suffix" {
  byte_length = local.random_char_length
}

#-------------------------------
# VPC
#-------------------------------
resource "google_compute_network" "anyscale_vpc" {
  #checkov:skip=CKV2_GCP_18:Firewall exists in firewall.tf
  count = var.module_enabled ? 1 : 0

  name        = local.computed_anyscale_vpcname
  description = var.vpc_description
  project     = var.anyscale_project_id

  auto_create_subnetworks         = var.auto_create_subnets
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = var.delete_default_internet_gateway_routes
  mtu                             = var.vpc_mtu
}
