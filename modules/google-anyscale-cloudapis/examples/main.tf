# ---------------------------------------------------------------------------------------------------------------------
# CREATE Anyscale Google VPC Resources
# This template creates VPC resources for Anyscale
# ---------------------------------------------------------------------------------------------------------------------
# locals {
#   full_labels = merge(tomap({
#     anyscale-cloud-id           = var.anyscale_cloud_id,
#     anyscale-deploy-environment = var.anyscale_deploy_env
#     }),
#     var.labels
#   )
# }

# ---------------------------------------------------------------------------------------------------------------------
# all_defaults
#   Enables all default APIs needed for Anyscale
# ---------------------------------------------------------------------------------------------------------------------
module "all_defaults" {
  source         = "../"
  module_enabled = true
}

# ---------------------------------------------------------------------------------------------------------------------
# Kitchen Sink
#   Enables the Compute and BigQuery APIs
# ---------------------------------------------------------------------------------------------------------------------
module "kitchen_sink" {
  source         = "../"
  module_enabled = true

  anyscale_project_id = var.google_project_id
  anyscale_activate_required_apis = [
    "compute.googleapis.com",
    "bigquery.googleapis.com",
    "certificatemanager.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "deploymentmanager.googleapis.com"
  ]
  anyscale_activate_optional_apis = [
    "monitoring.googleapis.com",
  ]

  disable_services_on_destroy = false
  disable_dependent_services  = false
}


# ---------------------------------------------------------------------------------------------------------------------
# test_no_resources
#   Do not create any resources
# ---------------------------------------------------------------------------------------------------------------------
module "test_no_resources" {
  source         = "../"
  module_enabled = false
}
