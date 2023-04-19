# --------------
# Defaults Test
# --------------
output "all_defaults_bucketname" {
  description = "The name of the all defaults anyscale resource."
  value       = module.all_defaults.cloudstorage_bucket_name
}
output "all_defaults_selflink" {
  description = "The selflink of the anyscale resource."
  value       = module.all_defaults.cloudstorage_bucket_selflink
}
output "all_defaults_url" {
  description = "The URL of the anyscale resource."
  value       = module.all_defaults.cloudstorage_bucket_url
}

# ------------------
# Kitchen Sink Test
# ------------------
output "kitchen_sink_bucketname" {
  description = "The name for the kitchen sink anyscale resource."
  value       = module.kitchen_sink.cloudstorage_bucket_name
}
output "kitchen_sink_selflink" {
  description = "The selflink of the kitchen sink anyscale resource."
  value       = module.kitchen_sink.cloudstorage_bucket_selflink
}
output "kitchen_sink_url" {
  description = "The URL of the kitchen sink anyscale resource."
  value       = module.kitchen_sink.cloudstorage_bucket_url
}

# -----------------
# No resource test
# -----------------
output "test_no_resources" {
  description = "The outputs of the no_resource resource - should all be empty"
  value       = module.test_no_resources
}
