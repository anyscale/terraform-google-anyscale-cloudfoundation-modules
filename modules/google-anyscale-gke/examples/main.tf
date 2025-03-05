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

  anyscale_activate_optional_apis = ["container.googleapis.com"]
}

# ---------------------------------------------------------------------------------------------------------------------
# GKE Standard Cluster
#   Create a GKE Cluster with as many defaults as possible
#   - Standard GKE Cluster
#   - No additional node pools
# ---------------------------------------------------------------------------------------------------------------------
module "gke_standard_autoscaling_vpc" {
  #checkov:skip=CKV_GCP_61:VPC Flow Logs are not required for this example.
  source         = "../../google-anyscale-vpc"
  module_enabled = true

  private_subnet_cidr     = "172.21.100.0/22"
  gke_services_range_cidr = "172.21.104.0/22"
  gke_pod_range_cidr      = "172.21.108.0/22"

  depends_on = [module.anyscale_cloudapis]
}

module "gke_standard_autoscaling_iam" {
  #checkov:skip=CKV_TF_1: Example code should use the latest version of the module
  #checkov:skip=CKV_TF_2: Example code should use the latest version of the module
  source         = "../../google-anyscale-iam"
  module_enabled = true

  anyscale_org_id                           = var.anyscale_organization_id
  create_anyscale_access_role               = true
  create_anyscale_cluster_node_service_acct = true # Set to true to bind to a GKE Service Account
  anyscale_cluster_node_service_acct_name   = "gke-standard-autoscaling"

  anyscale_project_id = var.google_project_id

  depends_on = [module.anyscale_cloudapis]
}

# trivy:ignore:avd-gcp-0051 # This is an example of a GKE Cluster with all defaults.
# trivy:ignore:avd-gcp-0056 # This is an example of a GKE Cluster with all defaults.
# trivy:ignore:avd-gcp-0059 # This is an example of a GKE Cluster with all defaults.
# trivy:ignore:avd-gcp-0061 # This is an example of a GKE Cluster with all defaults.
module "gke_standard_autoscaling" {
  # checkov:skip=CKV_GCP_21: 'Labels' are not sent as this is an example module.
  # checkov:skip=CKV_GCP_61:VPC Flow Logs are not required for this example.
  source         = "../"
  module_enabled = true

  gke_cluster_vpc        = module.gke_standard_autoscaling_vpc.vpc_selflink
  gke_cluster_subnet     = module.gke_standard_autoscaling_vpc.private_subnet_selflink
  ip_range_name_pods     = module.gke_standard_autoscaling_vpc.private_subnet_gke_pod_range_name
  ip_range_name_services = module.gke_standard_autoscaling_vpc.private_subnet_gke_services_range_name

  anyscale_project_id                 = var.google_project_id
  gke_cluster_gcp_iam_service_account = module.gke_standard_autoscaling_iam.iam_anyscale_cluster_node_service_acct_email

  deletion_protection = false # Default is true which does not allow TF to destroy the GKE Cluster

  labels = local.full_labels

  depends_on = [module.anyscale_cloudapis]
}


# ---------------------------------------------------------------------------------------------------------------------
# Standard GKE Cluster - No Autoscaling
#   Create a GKE Cluster
#   - Standard GKE Cluster
#   - Autoscaling disabled
#   - No additional node pools
# ---------------------------------------------------------------------------------------------------------------------
module "standard_gke_no_autoscaling_vpc" {
  #checkov:skip=CKV_GCP_61:VPC Flow Logs are not required for this example.
  source         = "../../google-anyscale-vpc"
  module_enabled = true

  private_subnet_cidr     = "172.22.100.0/22"
  gke_services_range_cidr = "172.22.104.0/22"
  gke_pod_range_cidr      = "172.22.108.0/22"

  depends_on = [module.anyscale_cloudapis]
}

module "standard_gke_no_autoscaling_iam" {
  #checkov:skip=CKV_TF_1: Example code should use the latest version of the module
  #checkov:skip=CKV_TF_2: Example code should use the latest version of the module
  source         = "../../google-anyscale-iam"
  module_enabled = true

  anyscale_org_id                           = var.anyscale_organization_id
  create_anyscale_access_role               = true
  create_anyscale_cluster_node_service_acct = true # Set to true to bind to a GKE Service Account
  anyscale_cluster_node_service_acct_name   = "standard-gke-noauto-node"

  anyscale_project_id = var.google_project_id

  depends_on = [module.anyscale_cloudapis]
}

# trivy:ignore:avd-gcp-0051 # This is an example of a GKE Cluster with all defaults.
# trivy:ignore:avd-gcp-0056 # This is an example of a GKE Cluster with all defaults.
# trivy:ignore:avd-gcp-0059 # This is an example of a GKE Cluster with all defaults.
# trivy:ignore:avd-gcp-0061 # This is an example of a GKE Cluster with all defaults.
module "standard_gke_no_autoscaling" {
  # checkov:skip=CKV_GCP_21: 'Labels' are not sent as this is an example module.
  # checkov:skip=CKV_GCP_61:VPC Flow Logs are not required for this example.
  source         = "../"
  module_enabled = true

  gke_cluster_vpc        = module.standard_gke_no_autoscaling_vpc.vpc_selflink
  gke_cluster_subnet     = module.standard_gke_no_autoscaling_vpc.private_subnet_selflink
  ip_range_name_pods     = module.standard_gke_no_autoscaling_vpc.private_subnet_gke_pod_range_name
  ip_range_name_services = module.standard_gke_no_autoscaling_vpc.private_subnet_gke_services_range_name

  anyscale_project_id = var.google_project_id
  gke_autoscaling_config = {
    enabled       = false
    min_cpu_cores = 0
    max_cpu_cores = 0
    min_memory_gb = 0
    max_memory_gb = 0
    gpu_resources = []
  }

  gke_cluster_gcp_iam_service_account = module.standard_gke_no_autoscaling_iam.iam_anyscale_cluster_node_service_acct_email

  deletion_protection = false # Default is true which does not allow TF to destroy the GKE Cluster

  labels = local.full_labels

  depends_on = [module.anyscale_cloudapis]
}

# ---------------------------------------------------------------------------------------------------------------------
# Autopilot GKE Cluster
#   Create a GKE Cluster
#   - Autopilot GKE Cluster
# ---------------------------------------------------------------------------------------------------------------------
module "autopilot_gke_vpc" {
  #checkov:skip=CKV_GCP_61:VPC Flow Logs are not required for this example.
  source         = "../../google-anyscale-vpc"
  module_enabled = true

  private_subnet_cidr     = "172.23.100.0/22"
  gke_services_range_cidr = "172.23.104.0/22"
  gke_pod_range_cidr      = "172.23.108.0/22"

  depends_on = [module.anyscale_cloudapis]
}
module "autopilot_gke_iam" {
  #checkov:skip=CKV_TF_1: Example code should use the latest version of the module
  #checkov:skip=CKV_TF_2: Example code should use the latest version of the module
  source         = "../../google-anyscale-iam"
  module_enabled = true

  anyscale_org_id                           = var.anyscale_organization_id
  create_anyscale_access_role               = true
  create_anyscale_cluster_node_service_acct = true # Set to true to bind to a GKE Service Account
  anyscale_cluster_node_service_acct_name   = "gke-cluster-autopilot"

  anyscale_project_id = var.google_project_id

  depends_on = [module.anyscale_cloudapis]
}

# trivy:ignore:avd-gcp-0051 # This is an example of a GKE Cluster with all defaults.
# trivy:ignore:avd-gcp-0056 # This is an example of a GKE Cluster with all defaults.
# trivy:ignore:avd-gcp-0059 # This is an example of a GKE Cluster with all defaults.
# trivy:ignore:avd-gcp-0061 # This is an example of a GKE Cluster with all defaults.
module "autopilot_gke" {
  # checkov:skip=CKV_GCP_21: 'Labels' are not sent as this is an example module.
  # checkov:skip=CKV_GCP_61:VPC Flow Logs are not required for this example.
  source         = "../"
  module_enabled = true

  gke_cluster_vpc        = module.autopilot_gke_vpc.vpc_selflink
  gke_cluster_subnet     = module.autopilot_gke_vpc.private_subnet_selflink
  ip_range_name_pods     = module.autopilot_gke_vpc.private_subnet_gke_pod_range_name
  ip_range_name_services = module.autopilot_gke_vpc.private_subnet_gke_services_range_name

  anyscale_project_id = var.google_project_id
  gke_autoscaling_config = {
    enabled       = false
    min_cpu_cores = 0
    max_cpu_cores = 0
    min_memory_gb = 0
    max_memory_gb = 0
    gpu_resources = []
  }

  gke_cluster_gcp_iam_service_account = module.autopilot_gke_iam.iam_anyscale_cluster_node_service_acct_email

  deletion_protection = false # Default is true which does not allow TF to destroy the GKE Cluster

  labels = local.full_labels

  depends_on = [module.anyscale_cloudapis]
}

# ---------------------------------------------------------------------------------------------------------------------
# Do not create any resources
# ---------------------------------------------------------------------------------------------------------------------
module "test_no_resources" {
  source         = "../"
  module_enabled = false

  gke_cluster_vpc     = "none"
  anyscale_project_id = "none"
}
