# ---------------------------------------------------------------------------------------------------------------------
# CREATE Anyscale Google Logging Sink Resources
# This template creates Logging Sink Resources for Anyscale
# ---------------------------------------------------------------------------------------------------------------------

module "filestore_cloudapis" {
  source         = "../../google-anyscale-cloudapis"
  module_enabled = true
}

# ---------------------------------------------------------------------------------------------------------------------
# all_defaults
#   Create a FileStore with all defaults
#   Includes creating a VPC
# ---------------------------------------------------------------------------------------------------------------------
module "all_defaults" {
  source         = "../"
  module_enabled = true

  depends_on = [
    module.filestore_cloudapis
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# test_no_resources
#   Do not create any resources
# ---------------------------------------------------------------------------------------------------------------------
module "test_no_resources" {
  source = "../"
}
