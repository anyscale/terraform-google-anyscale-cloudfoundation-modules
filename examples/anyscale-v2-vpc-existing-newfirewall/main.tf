# ---------------------------------------------------------------------------------------------------------------------
# Create core Anyscale v2 Stack resources in Google Cloud within an existing project
#   Creates a v2 stack including
#     - Enabling Cloud APIs on the Project
#     - Cloud Storage Bucket
#     - IAM Roles
#     - VPC Firewall
#   This does NOT create a project.
#   This does not create a new VPC.
#
#   This example should be evaluated for use in a production environment to ensure it meets
#   all security and compliance requirements.
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
  # Set enable_anyscale_vpc_firewall to true to create a new firewall policy
  enable_anyscale_vpc_firewall = true
  # Allow ingress access from CIDR (VPN, Direct Connect, etc. CIDR Range)
  anyscale_vpc_firewall_allow_access_from_cidrs = var.customer_ingress_cidr_ranges
  # Existing Google Cloud VPC Proxy subnet CIDR
  anyscale_vpc_proxy_subnet_cidr = var.anyscale_vpc_proxy_subnet_cidr
  # Optional - Allow SSH access from the customer ingress CIDR range (default is true)
  #   Port 22 is no longer required for end users to access the clusters.
  security_group_enable_ssh_access = false

  # Cloud Storage (Bucket) Related
  anyscale_bucket_location = "US"

  # Filestore Related
  enable_anyscale_filestore = false
}
