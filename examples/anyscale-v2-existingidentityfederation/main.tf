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

module "google_anyscale_v2_existingidentityfederation" {
  source = "../.."
  labels = local.full_labels

  anyscale_deploy_env      = var.anyscale_deploy_env
  anyscale_cloud_id        = var.anyscale_cloud_id
  anyscale_organization_id = var.anyscale_org_id

  common_prefix   = "anyscale-tf-"
  use_common_name = true

  # Project Related
  anyscale_project_billing_account = var.billing_account_id
  anyscale_project_folder_id       = var.root_folder_number

  # IAM Related
  existing_workload_identity_provider_name = var.existing_workload_identity_provider_name

  # VPC Related
  anyscale_vpc_public_subnet_cidr = "172.27.100.0/22"

  # Firewall Related
  anyscale_vpc_firewall_allow_access_from_cidrs = var.customer_ingress_cidr_ranges

  # Cloud Storage (Bucket) Related
  anyscale_bucket_location = "US"
}
