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

# --------------------------------------------------------------
# Create a Fireall using All Defaults
#   The firewall that is created does not support Anyscale
#   Includes creating a VPC
# --------------------------------------------------------------
module "all_defaults_vpc" {
  source         = "../../google-anyscale-vpc"
  module_enabled = true

  public_subnet_cidr = "172.21.101.0/24"
}

module "all_defaults" {
  source         = "../"
  module_enabled = true

  vpc_name = module.all_defaults_vpc.vpc_name
  vpc_id   = module.all_defaults_vpc.vpc_id
  # vpc_self_link       = module.all_defaults_vpc.vpc_selflink
}

# --------------------------------------------------------------
# Create a Firewall that supports Anyscale and Public Subnets
#   Includes creating a VPC
# --------------------------------------------------------------
locals {
  public_subnet_cidr = "172.21.102.0/24"
}
module "anyscale_firewall_public_vpc" {
  source         = "../../google-anyscale-vpc"
  module_enabled = true

  public_subnet_cidr       = local.public_subnet_cidr
  anyscale_vpc_name_prefix = "anyscale-tf-vpc-pub-"
}

module "anyscale_firewall_public" {
  source         = "../"
  module_enabled = true

  vpc_name = module.anyscale_firewall_public_vpc.vpc_name
  vpc_id   = module.anyscale_firewall_public_vpc.vpc_id

  ingress_with_self_cidr_range = [local.public_subnet_cidr]
  ingress_from_cidr_map = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

# --------------------------------------------------------------
# Create a Firewall that supports Anyscale and Private Subnets
#   Includes creating a VPC
# --------------------------------------------------------------
locals {
  private_subnet_cidr = "172.21.103.0/24"
}
module "anyscale_firewall_private_vpc" {
  source         = "../../google-anyscale-vpc"
  module_enabled = true

  private_subnet_cidr      = local.private_subnet_cidr
  anyscale_vpc_name_prefix = "anyscale-tf-vpc-priv-"
}

module "anyscale_firewall_private" {
  source         = "../"
  module_enabled = true

  vpc_name = module.anyscale_firewall_private_vpc.vpc_name
  vpc_id   = module.anyscale_firewall_private_vpc.vpc_id

  default_ingress_cidr_range = [var.default_ingress_cidr_range]
  ingress_from_cidr_map = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = "10.100.10.10/32"
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = "10.100.10.10/32,35.235.240.0/20"
    }
  ]
}

# --------------------------------------------------------------
# Kitchen Sink
#  Use as many options as possible
#  Includes creating a VPC
# --------------------------------------------------------------
locals {
  kitchensink_subnet_cidr = "172.21.104.0/24"
}
module "kitchen_sink_vpc" {
  source = "../../google-anyscale-vpc"

  module_enabled = true

  anyscale_project_id = var.google_project_id
  # google_region       = var.google_region

  private_subnet_cidr      = local.kitchensink_subnet_cidr
  anyscale_vpc_name_prefix = "anyscale-tf-vpc-kitchensink-"
}
module "kitchen_sink" {
  source         = "../"
  module_enabled = true

  # google_region       = var.google_region
  anyscale_project_id = var.google_project_id

  vpc_name = module.kitchen_sink_vpc.vpc_name
  vpc_id   = module.kitchen_sink_vpc.vpc_id

  firewall_policy_name         = "anyscale-tf-kitchensink-policy"
  firewall_policy_description  = "This is the Anyscale Kitchen Sink Policy"
  enable_firewall_rule_logging = false

  ingress_with_self_cidr_range = [local.kitchensink_subnet_cidr]
  ingress_with_self_map = [
    { rule = "https-443-tcp" },
    { rule = "http-80-tcp" },
    { rule = "ssh-tcp" }
  ]

  default_ingress_cidr_range = compact(concat(["10.100.10.10/32", "10.100.10.11/32"], [var.default_ingress_cidr_range]))
  ingress_from_cidr_map = [
    { rule = "nfs-tcp" }
  ]

}

# --------------------------------------------------------------
# Do not create any resources
# --------------------------------------------------------------
module "test_no_resources" {
  source = "../"

  module_enabled = false
  # google_region       = var.google_region
  anyscale_project_id = ""
  vpc_name            = ""
  vpc_id              = ""
}
