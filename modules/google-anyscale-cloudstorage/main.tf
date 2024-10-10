locals {
  random_char_length = var.random_char_length >= 4 && var.random_char_length % 2 == 0 ? var.random_char_length / 2 : 0

  anyscale_bucketname = var.anyscale_bucket_name != null ? var.anyscale_bucket_name : var.anyscale_bucket_name_prefix
  computed_anyscale_bucketname = var.enable_random_name_suffix ? format(
    "%s%s",
    local.anyscale_bucketname,
    random_id.random_char_suffix.hex,
  ) : local.anyscale_bucketname

  module_labels = merge(
    tomap({
      tf_sub_module = "google-anyscale-cloudstorage"
    }),
  var.labels)

  cors_enabled = length(var.cors_rules) > 0
  cors         = local.cors_enabled ? var.cors_rules : []

  retention_policy_enabled = length(keys(var.retention_policy)) > 0 ? true : false
  bucket_logging_enabled   = length(keys(var.bucket_logging)) > 0 ? true : false
}

#-------------------------------
# Random Strings for Bucket Name
#-------------------------------
resource "random_id" "random_char_suffix" {
  byte_length = local.random_char_length
}

#-------------------------------
# Google Storage Bucket
#-------------------------------
#tfsec:ignore:google-storage-bucket-encryption-customer-key
resource "google_storage_bucket" "anyscale_bucket" {
  #checkov:skip=CKV_GCP_78:This bucket is primarily used for logs. Versioning can be enabled, but default is set to false.
  count = var.module_enabled ? 1 : 0

  name     = local.computed_anyscale_bucketname
  location = var.bucket_location
  project  = var.anyscale_project_id

  storage_class               = var.bucket_storage_class
  public_access_prevention    = var.bucket_public_access_prevention
  force_destroy               = var.bucket_force_destroy
  uniform_bucket_level_access = var.bucket_uniform_level_access

  versioning {
    enabled = var.bucket_versioning
  }

  dynamic "encryption" {
    # If an encryption key name is set for this bucket name -> Create a single encryption block
    for_each = var.bucket_encryption_key_name != null ? [1] : []
    content {
      default_kms_key_name = var.bucket_encryption_key_name
    }
  }

  dynamic "cors" {
    for_each = local.cors
    content {
      origin          = lookup(cors.value, "origins", null)
      method          = lookup(cors.value, "methods", null)
      response_header = lookup(cors.value, "response_headers", null)
      max_age_seconds = lookup(cors.value, "max_age_seconds", null)
    }
  }

  dynamic "retention_policy" {
    for_each = local.retention_policy_enabled ? [1] : []
    content {
      is_locked        = lookup(var.retention_policy, "is_locked", null)
      retention_period = lookup(var.retention_policy, "retention_period", null)
    }
  }


  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }
      condition {
        age                        = lookup(lifecycle_rule.value.condition, "age", null)
        created_before             = lookup(lifecycle_rule.value.condition, "created_before", null)
        with_state                 = lookup(lifecycle_rule.value.condition, "with_state", lookup(lifecycle_rule.value.condition, "is_live", false) ? "LIVE" : null)
        matches_storage_class      = contains(keys(lifecycle_rule.value.condition), "matches_storage_class") ? split(",", lifecycle_rule.value.condition["matches_storage_class"]) : null
        matches_prefix             = contains(keys(lifecycle_rule.value.condition), "matches_prefix") ? split(",", lifecycle_rule.value.condition["matches_prefix"]) : null
        matches_suffix             = contains(keys(lifecycle_rule.value.condition), "matches_suffix") ? split(",", lifecycle_rule.value.condition["matches_suffix"]) : null
        num_newer_versions         = lookup(lifecycle_rule.value.condition, "num_newer_versions", null)
        custom_time_before         = lookup(lifecycle_rule.value.condition, "custom_time_before", null)
        days_since_custom_time     = lookup(lifecycle_rule.value.condition, "days_since_custom_time", null)
        days_since_noncurrent_time = lookup(lifecycle_rule.value.condition, "days_since_noncurrent_time", null)
        noncurrent_time_before     = lookup(lifecycle_rule.value.condition, "noncurrent_time_before", null)
      }
    }
  }

  dynamic "logging" {
    for_each = local.bucket_logging_enabled ? [1] : []
    content {
      log_bucket        = lookup(var.bucket_logging, "log_bucket", null)
      log_object_prefix = lookup(var.bucket_logging, "log_object_prefix", null)
    }
  }

  labels = local.module_labels
}

locals {
  bucket_iam_member_enabled = var.module_enabled && (length(var.bucket_iam_member_roles) > 0 || length(var.bucket_iam_member_additional_roles) > 0) && length(var.bucket_iam_members) > 0

  combined_roles = distinct(concat(var.bucket_iam_member_roles, var.bucket_iam_member_additional_roles))

  role_member_pairs = flatten([
    for role_index, role in local.combined_roles : [
      for member_index, member in var.bucket_iam_members : {
        role   = role
        member = member
      }
    ]
  ])

  role_member_pairs_map = { for idx, pair in local.role_member_pairs : tostring(idx) => pair }
}

resource "google_storage_bucket_iam_member" "anyscale_bucket" {
  for_each = local.bucket_iam_member_enabled ? local.role_member_pairs_map : {}

  bucket = google_storage_bucket.anyscale_bucket[0].name
  role   = each.value.role
  member = each.value.member
}
