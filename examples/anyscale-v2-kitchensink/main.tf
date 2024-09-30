# ---------------------------------------------------------------------------------------------------------------------
# Create core Anyscale v2 Stack resources in Google Cloud with as many variables as possible
#   Creates a v2 stack including
#     - Project
#     - Enabling Cloud APIs on the Project
#     - Cloud Storage Bucket
#     - IAM Roles
#     - VPC with public subnets and NAT
#     - VPC Firewall
#     - FileStore (Standard)
#     - MemoryStore (Redis)
# ---------------------------------------------------------------------------------------------------------------------
locals {
  full_labels = merge(tomap({
    anyscale-cloud-id = var.anyscale_cloud_id,
    deploy_env        = "test"
    }),
    var.labels
  )

}

module "google_anyscale_v2_kitchensink" {
  source = "../.."
  labels = local.full_labels

  anyscale_cloud_id        = var.anyscale_cloud_id
  anyscale_organization_id = var.anyscale_org_id

  common_prefix      = "anyscale-ks-"
  use_common_name    = false
  random_char_length = 4

  enable_cloud_logging_monitoring = true

  # Project Related
  anyscale_project_name            = "anyscale-tf-ks-project"
  anyscale_project_billing_account = var.billing_account_id
  anyscale_project_folder_id       = var.root_project_id
  anyscale_project_labels = {
    "anyscale-project-label" = "anyscale-project-label-value"
  }

  # VPC Related
  anyscale_vpc_name_prefix = "anyscale-tf-ks-vpc-"
  anyscale_vpc_description = "Anyscale Terraform KitchenSink VPC"

  anyscale_vpc_public_subnet_cidr = "172.28.100.0/22"

  # Firewall Related
  enable_anyscale_vpc_firewall                  = true
  anyscale_vpc_firewall_policy_name             = "anyscale-tf-ks-vpc-fw-policy"
  anyscale_vpc_firewall_policy_description      = "Anyscale Terraform KitchenSink VPC Firewall Policy"
  anyscale_vpc_firewall_allow_access_from_cidrs = var.customer_ingress_cidr_ranges
  allow_ssh_from_google_ui                      = true
  ingress_from_machine_pool_cidr_ranges         = ["10.100.1.0/24"]

  # Cloud Storage (Bucket) Related
  enable_anyscale_gcs           = true
  anyscale_bucket_prefix        = "anyscale-tf-ks-gcs-"
  anyscale_bucket_location      = "US"
  anyscale_bucket_storage_class = "STANDARD"
  anyscale_bucket_lifecycle_rules = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        age = 90
      }
    }
  ]
  anyscale_bucket_cors_rules = [
    {
      origins          = ["https://console.anyscale.com"]
      methods          = ["GET"]
      response_headers = ["*"]
      max_age_seconds  = 3600
    }
  ]
  bucket_iam_binding_override_roles = ["roles/storage.objectAdmin", "roles/storage.legacyBucketReader"]

  # Filestore Related
  enable_anyscale_filestore         = true
  anyscale_filestore_name           = "anyscale-tf-ks-filestore"
  anyscale_filestore_fileshare_name = "anyscale_tf_ks"
  anyscale_filestore_description    = "Anyscale Terraform KitchenSink Filestore"
  anyscale_filestore_tier           = "STANDARD"
  anyscale_filestore_location       = "us-central1-a"
  anyscale_filestore_capacity_gb    = 2048

  # IAM Related
  enable_anyscale_iam                          = true
  anyscale_iam_access_service_acct_name_prefix = "anyscale-tf-ks-acct-"
  anyscale_iam_access_service_acct_description = "Anyscale Terraform KitchenSink IAM Access Role"
  anyscale_workload_identity_pool_name         = "anyscale-tf-ks-workload-id-pool"
  anyscale_workload_identity_pool_display_name = "Anyscale TF KS Identity Pool"
  anyscale_workload_identity_pool_description  = "Anyscale Terraform KitchenSink Workload Identity Pool"

  anyscale_cluster_node_service_acct_name        = "anyscale-tf-ks-cluster"
  anyscale_cluster_node_service_acct_description = "Anyscale Terraform KitchenSink IAM Cluster Node Role"

  # Memorystore Related
  enable_anyscale_memorystore       = true
  anyscale_memorystore_name_prefix  = "anyscale-tf-ks-memorystore-"
  anyscale_memorystore_display_name = "Anyscale TF KS Memorystore"
  anyscale_memorystore_labels = {
    "anyscale-memorystore-label" = "anyscale-memorystore-label-value"
  }
}
