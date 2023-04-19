# --------------
# Defaults Test
# --------------
output "all_defaults_id" {
  description = "The arn of the anyscale resource."
  value       = module.all_defaults.project_id
}

output "all_defaults_number" {
  description = "The ID of the anyscale resource."
  value       = module.all_defaults.project_number
}

output "all_defaults_name" {
  description = "The name of the anyscale resource."
  value       = module.all_defaults.project_name
}

# # ------------------
# # Kitchen Sink Test
# # ------------------
output "kitchen_sink_id" {
  description = "The arn of the kitchen sink anyscale resource."
  value       = module.kitchen_sink.project_id
}

output "kitchen_sink_number" {
  description = "The ID of the kitchen sink anyscale resource."
  value       = module.kitchen_sink.project_number
}

output "kitchen_sink_name" {
  description = "The Name of the anyscale resource."
  value       = module.kitchen_sink.project_name
}


# -----------------
# No resource test
# -----------------
output "test_no_resources" {
  description = "The outputs of the no_resource resource - should all be empty"
  value       = module.test_no_resources
}
