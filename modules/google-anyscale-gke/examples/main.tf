# ---------------------------------------------------------------------------------------------------------------------
# CREATE Anyscale Google GKE Resources
# This template creates GKE resources for Anyscale including
# - VPC
# - Service Account
# - GKE Cluster
# - GKE Node Pool
# - GKE Node Pool Autoscaler
# ---------------------------------------------------------------------------------------------------------------------
locals {
  full_labels = merge(tomap({
    anyscale-cloud-id           = var.anyscale_cloud_id,
    anyscale-deploy-environment = var.anyscale_deploy_env
    }),
    var.labels
  )
}
# We need APIs and a VPC for all resources below - no need to create a separate module for this
module "anyscale_cloudapis" {
  source         = "../../google-anyscale-cloudapis"
  module_enabled = true
}
module "anyscale_vpc" {
  #checkov:skip=CKV_GCP_61:VPC Flow Logs are not required for this example.
  source         = "../../google-anyscale-vpc"
  module_enabled = true

  private_subnet_cidr     = "172.21.100.0/22"
  gke_services_range_cidr = "172.21.104.0/22"
  gke_pod_range_cidr      = "172.21.108.0/22"
}

# ---------------------------------------------------------------------------------------------------------------------
# all_defaults
#   Create a GKE Cluster with all defaults
# ---------------------------------------------------------------------------------------------------------------------
# trivy:ignore:avd-gcp-0051 # This is an example of a GKE Cluster with all defaults.
# trivy:ignore:avd-gcp-0056 # This is an example of a GKE Cluster with all defaults.
# trivy:ignore:avd-gcp-0059 # This is an example of a GKE Cluster with all defaults.
# trivy:ignore:avd-gcp-0061 # This is an example of a GKE Cluster with all defaults.
module "all_defaults" {
  # checkov:skip=CKV_GCP_21: 'Labels' are not sent as this is an example module.
  # checkov:skip=CKV_GCP_61:VPC Flow Logs are not required for this example.
  source         = "../"
  module_enabled = true
  depends_on = [
    module.anyscale_cloudapis
  ]

  gke_cluster_vpc        = module.anyscale_vpc.vpc_selflink
  gke_cluster_subnet     = module.anyscale_vpc.private_subnet_selflink
  ip_range_name_pods     = module.anyscale_vpc.private_subnet_gke_pod_range_name
  ip_range_name_services = module.anyscale_vpc.private_subnet_gke_services_range_name

  deletion_protection = false

  labels = local.full_labels
}
