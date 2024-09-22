# ---------------------------------------------------------------------------------------------------------------------
# Create core Anyscale v2 Stack resources in Google Cloud with common name
#   Creates a v2 stack including
#     - Project
#     - Enabling Cloud APIs on the Project
#     - Cloud Storage Bucket
#     - IAM Roles
#     - VPC with publicly routed subnets (no internal)
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

  common_prefix   = "anyscale-tf-"
  use_common_name = true
  # Project Related
  anyscale_project_billing_account = var.billing_account_id
  anyscale_project_folder_id       = var.root_folder_number

  # VPC Related
  anyscale_vpc_public_subnet_cidr = "172.25.100.0/22"
  anyscale_vpc_proxy_subnet_cidr  = "172.25.104.0/22"

  # Firewall Related
  anyscale_vpc_firewall_allow_access_from_cidrs = var.customer_ingress_cidr_ranges

  # Cloud Storage (Bucket) Related
  anyscale_bucket_location = "US"

  # Enable Cloud Logging on GCP - this will enable sending logs and metrics to GCP Logs and Monitoring
  enable_cloud_logging_monitoring = true

  # Disables the Anyscale Logging Sink submodule. Setting this to false will not override the _Default Sink which will then send syslog events to the Default sink.
  enable_anyscale_loggingsink = false
}
