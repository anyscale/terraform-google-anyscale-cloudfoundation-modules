# ---------------------------------------------------------------------------------------------------------------------
# CREATE Anyscale Google Project Resources
# This template creates Project resources for Anyscale
# ---------------------------------------------------------------------------------------------------------------------
locals {
  full_labels = merge(tomap({
    anyscale-cloud-id           = var.anyscale_cloud_id,
    anyscale-deploy-environment = var.anyscale_deploy_env
    }),
    var.labels
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Create a Project with minimal optional parameters
# ---------------------------------------------------------------------------------------------------------------------
module "all_defaults" {
  source = "../"

  module_enabled = true

  folder_id          = var.folder_id
  billing_account_id = var.billing_account_id

  labels = local.full_labels
}

# ---------------------------------------------------------------------------------------------------------------------
# Use all params and build an Project.
# ---------------------------------------------------------------------------------------------------------------------
module "kitchen_sink" {
  source = "../"

  module_enabled = true

  folder_id          = var.folder_id
  billing_account_id = var.billing_account_id

  anyscale_project_name = "anyscale-tf-ks-name-ex"
  anyscale_project_id   = "anyscale-tf-ks-proj-ex"

  enable_random_name_suffix = false
  deletion_policy           = "DELETE"

  labels = merge(
    tomap({
      example = "kitchen_sink"
    }),
    local.full_labels
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Do not create any resources
# ---------------------------------------------------------------------------------------------------------------------
module "test_no_resources" {
  source = "../"

  billing_account_id = ""
  module_enabled     = false
}
