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

module "google_anyscale_v2_vpc_shared" {
  source = "../.."
  labels = local.full_labels

  anyscale_deploy_env      = var.anyscale_deploy_env
  anyscale_cloud_id        = var.anyscale_cloud_id
  anyscale_organization_id = var.anyscale_org_id

  common_prefix   = "tf-sharedvpc-"
  use_common_name = true

  # Project Related
  existing_project_id = var.existing_project_id

  # VPC Related
  existing_vpc_name        = var.existing_vpc_name
  existing_vpc_subnet_name = var.existing_vpc_subnet_name
  shared_vpc_project_id    = var.shared_vpc_project_id

  # Firewall Related
  enable_anyscale_vpc_firewall = var.enable_anyscale_vpc_firewall # determines if a new firewall is created

  anyscale_vpc_firewall_allow_access_from_cidrs = var.customer_ingress_cidr_ranges # determines what cidr ranges to allow access from

  # Cloud Storage (Bucket) Related
  anyscale_bucket_location = "US"

  # Filestore Related
  anyscale_filestore_network_conect_mode = "PRIVATE_SERVICE_ACCESS"
}
