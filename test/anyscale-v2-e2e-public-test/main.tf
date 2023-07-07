# ---------------------------------------------------------------------------------------------------------------------
# Create core Anyscale v2 Stack resources in Google Cloud with a public network
#   Creates a v2 stack including
#     - Project
#     - Enabling Cloud APIs on the Project
#     - Cloud Storage Bucket
#     - IAM Roles
#     - VPC with public subnets (no public IPs) and NAT
#     - VPC Firewall
#     - FileStore (Standard)
# ---------------------------------------------------------------------------------------------------------------------
locals {
  full_labels = merge(tomap({
    anyscale-cloud-id           = var.anyscale_cloud_id,
    anyscale-deploy-environment = var.anyscale_deploy_env
    }),
    var.labels
  )

}

module "google_anyscale_v2_commonname" {
  source = "../.."
  labels = local.full_labels

  anyscale_deploy_env      = var.anyscale_deploy_env
  anyscale_cloud_id        = var.anyscale_cloud_id
  anyscale_organization_id = var.anyscale_org_id

  anyscale_workload_identity_account_id = var.workload_identity_account_id

  common_prefix   = "anyscale-tf-"
  use_common_name = true
  # Project Related
  anyscale_project_billing_account = var.billing_account_id
  anyscale_project_folder_id       = var.root_folder_number

  # VPC Related
  anyscale_vpc_public_subnet_cidr = "172.25.100.0/22"

  # Firewall Related
  anyscale_vpc_firewall_allow_access_from_cidrs = var.customer_ingress_cidr_ranges

  # Cloud Storage (Bucket) Related
  anyscale_bucket_location = "US"
}
