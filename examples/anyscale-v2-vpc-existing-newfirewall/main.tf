# ---------------------------------------------------------------------------------------------------------------------
# Create core Anyscale v2 Stack resources in Google Cloud within an existing project
#   Creates a v2 stack including
#     - Enabling Cloud APIs on the Project
#     - Cloud Storage Bucket
#     - IAM Roles
#     - VPC with public subnets
#     - VPC Firewall
#     - FileStore (Standard)
#   This does NOT create a project.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  full_labels = merge(tomap({
    anyscale-cloud-id           = var.anyscale_cloud_id,
    anyscale-deploy-environment = var.anyscale_deploy_env
    }),
    var.labels
  )

}

data "google_compute_network" "existing_vpc" {
  name    = var.existing_vpc_name
  project = var.existing_project_id
}

module "google_anyscale_v2_vpc_existing" {
  source = "../.."
  labels = local.full_labels

  anyscale_deploy_env      = var.anyscale_deploy_env
  anyscale_cloud_id        = var.anyscale_cloud_id
  anyscale_organization_id = var.anyscale_org_id

  common_prefix   = "tf-existingvpc-"
  use_common_name = true

  # Project Related
  existing_project_id = var.existing_project_id

  # VPC Related
  existing_vpc_name        = var.existing_vpc_name
  existing_vpc_subnet_name = var.existing_vpc_subnet_name
  existing_vpc_id          = data.google_compute_network.existing_vpc.id

  # Firewall Related
  enable_anyscale_vpc_firewall                  = true
  anyscale_vpc_firewall_allow_access_from_cidrs = var.customer_ingress_cidr_ranges   # VPC Firewall allow access from CIDR (VPN CIDR Range)
  anyscale_vpc_proxy_subnet_cidr                = var.anyscale_vpc_proxy_subnet_cidr # Existing VPC Proxy subnet CIDR

  # Cloud Storage (Bucket) Related
  anyscale_bucket_location = "US"

  # Filestore Related
  enable_anyscale_filestore = false
}
