# -------------------------------------------
# All Defaults Test
# -------------------------------------------
output "all_defaults_anyscale_memorystore_id" {
  description = "All Defaults - Anyscale Memorystore ID"
  value       = module.all_defaults.anyscale_memorystore_id
}
output "all_defaults_anyscale_memorystore_host" {
  description = "All Defaults - Anyscale Memorystore Host Name"
  value       = module.all_defaults.anyscale_memorystore_host
}
output "all_defaults_anyscale_memorystore_port" {
  description = "All Defaults - Anyscale Memorystore Port"
  value       = module.all_defaults.anyscale_memorystore_port
}

# -------------------------------------------
# Kitchen Sink Test
# -------------------------------------------
output "kitchen_sink_anyscale_memorystore_id" {
  description = "Kitchen Sink - Anyscale Memorystore ID"
  value       = module.kitchen_sink.anyscale_memorystore_id
}
output "kitchen_sink_anyscale_memorystore_host" {
  description = "Kitchen Sink - Anyscale Memorystore Host Name"
  value       = module.kitchen_sink.anyscale_memorystore_host
}
output "kitchen_sink_anyscale_memorystore_port" {
  description = "Kitchen Sink - Anyscale Memorystore Port"
  value       = module.kitchen_sink.anyscale_memorystore_port
}
output "kitchen_sink_anyscale_memorystore_region" {
  description = "Kitchen Sink - Anyscale Memorystore Region"
  value       = module.kitchen_sink.anyscale_memorystore_region
}
output "kitchen_sink_anyscale_memorystore_current_location_id" {
  description = "Kitchen Sink - Anyscale Memorystore Current Location ID"
  value       = module.kitchen_sink.anyscale_memorystore_current_location_id
}
output "kitchen_sink_anyscale_memorystore_maintenance_schedule" {
  description = "Kitchen Sink - Anyscale Memorystore Maintenance Schedule"
  value       = module.kitchen_sink.anyscale_memorystore_maintenance_schedule
}

# -----------------
# No resource test
# -----------------
output "test_no_resources" {
  description = "The outputs of the no_resource resource - should be empty"
  value       = module.test_no_resources
}
