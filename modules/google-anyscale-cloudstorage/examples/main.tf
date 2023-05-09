# ---------------------------------------------------------------------------------------------------------------------
# CREATE Anyscale Google Cloud Storage Resources
# This template creates Cloud Storage resources for Anyscale
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
# Create a Cloud Storage Bucket with minimal optional parameters
# ---------------------------------------------------------------------------------------------------------------------
module "all_defaults" {
  source         = "../"
  module_enabled = true

  labels = local.full_labels
}

# ---------------------------------------------------------------------------------------------------------------------
# Create a Cloud Storage Bucket with as many parameters as possible
# ---------------------------------------------------------------------------------------------------------------------
module "kitchen_sink_iam" {
  source         = "../../google-anyscale-iam"
  module_enabled = true

  anyscale_project_id = var.google_project_id
  anyscale_org_id     = var.anyscale_organization_id
}
module "kitchen_sink" {
  source         = "../"
  module_enabled = true

  anyscale_project_id = var.google_project_id
  labels              = local.full_labels

  bucket_location           = var.google_region
  anyscale_bucket_name      = "anyscale-terraform-test-bucket"
  enable_random_name_suffix = false

  bucket_public_access_prevention = "enforced"
  bucket_force_destroy            = "true"
  bucket_uniform_level_access     = "true"
  bucket_versioning               = "true"

  cors_rules = [
    {
      response_headers = ["*"]
      methods          = ["PUT", "POST"]
      origins          = ["https://console.anyscale.com"]
      max_age_seconds  = 3000
    },
    {
      response_headers = ["*"]
      methods          = ["GET"]
      origins          = ["https://console.anyscale-staging.com"]
      max_age_seconds  = 3600
    }
  ]

  lifecycle_rules = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        age = "120"
      }
    },
    {
      action = {
        type = "Delete"
      }
      condition = {
        num_newer_versions = 5,
        is_live            = false
      }
    },
    {
      action = {
        type = "Delete"
      }
      condition = {
        days_since_noncurrent_time = 30
      }
    }
  ]

  bucket_logging = {
    log_bucket        = module.all_defaults.cloudstorage_bucket_name,
    log_object_prefix = "/log_test/"
  }

  bucket_iam_binding_members = [
    "serviceAccount:${module.kitchen_sink_iam.iam_anyscale_access_role_email}",
    "serviceAccount:${module.kitchen_sink_iam.iam_anyscale_cluster_node_role_email}"
  ]

  bucket_iam_binding_override_roles = [
    "roles/storage.objectViewer",
    "roles/storage.objectCreator"
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Do not create any resources
# ---------------------------------------------------------------------------------------------------------------------
module "test_no_resources" {
  source         = "../"
  module_enabled = false
}
