# -------------------------------------------
# All Defaults Test
# -------------------------------------------
output "all_default_enabled_apis" {
  description = "Enabled APIs for All Defaults"
  value       = module.all_defaults.enabled_apis
}

# output "all_defaults_enabled_api_identities" {
#   description = "Enabled API identities for All Defaults"
#   value       = module.all_defaults.enabled_api_identities
# }

# -------------------------------------------
# Kitchen Sink Test
# -------------------------------------------
output "kitchen_sink_enabled_apis" {
  description = "Enabled APIs for Kitchen Sink"
  value       = module.kitchen_sink.enabled_apis
}

# output "kitchen_sink_enabled_api_identities" {
#   description = "Enabled API identities for Kitchen Sink"
#   value       = module.kitchen_sink.enabled_api_identities
# }

# -----------------
# No resource test
# -----------------
output "test_no_resources" {
  description = "The outputs of the no_resource resource - should be empty"
  value       = module.test_no_resources
}
