# ---------------------------------------------------------------------------------------------------------------------
# Create core Anyscale v2 Stack resources in Google Cloud with a private network
#   Creates a v2 stack including
#     - Project
#     - Enabling Cloud APIs on the Project
#     - Cloud Storage Bucket
#     - IAM Roles
#     - VPC with private subnets (no public IPs) and NAT
#     - VPC Firewall
#     - FileStore (Standard)
#     - MemoryStore (Redis)
# ---------------------------------------------------------------------------------------------------------------------
locals {
  full_labels = merge(tomap({
    anyscale-cloud-id           = var.anyscale_cloud_id,
    anyscale-deploy-environment = var.anyscale_deploy_env
    }),
    var.labels
  )

}

module "google_anyscale_v2_privatenetwork" {
  source = "../.."
  labels = local.full_labels

  anyscale_deploy_env      = var.anyscale_deploy_env
  anyscale_cloud_id        = var.anyscale_cloud_id
  anyscale_organization_id = var.anyscale_org_id

  common_prefix   = "anyscale-prv-"
  use_common_name = true
  # Project Related
  anyscale_project_billing_account = var.billing_account_id
  anyscale_project_folder_id       = var.root_project_id

  # VPC Related
  anyscale_vpc_private_subnet_cidr = "172.26.100.0/22"
  anyscale_vpc_proxy_subnet_cidr   = "192.168.0.0/22"

  # Firewall Related
  anyscale_vpc_firewall_allow_access_from_cidrs = var.customer_ingress_cidr_ranges

  # Filestore Related
  # anyscale_filestore_tier        = "STANDARD"
  # anyscale_filestore_location    = "us-central1-a"
  # anyscale_filestore_capacity_gb = 3000

  # Cloud Storage (Bucket) Related
  anyscale_bucket_location = "US"

  # Memorystore Related
  enable_anyscale_memorystore = true
}
