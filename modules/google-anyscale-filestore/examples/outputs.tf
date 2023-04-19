# -------------------------------------------
# All Defaults Test
# -------------------------------------------
output "all_defaults_anyscale_filestore_id" {
  description = "All Defaults - Anyscale Filestore ID"
  value       = module.all_defaults.anyscale_filestore_id
}
output "all_defaults_anyscale_filestore_name" {
  description = "All Defaults - Anyscale Filestore Name"
  value       = module.all_defaults.anyscale_filestore_name
}
output "all_defaults_anyscale_filestore_fileshare_name" {
  description = "All Defaults - Anyscale Fileshare Name"
  value       = module.all_defaults.anyscale_filestore_fileshare_name
}
output "all_defaults_anyscale_filestore_fileshare_source_backup" {
  description = "All Defaults - Anyscale Fileshare Source Backup"
  value       = module.all_defaults.anyscale_filestore_fileshare_source_backup
}
output "all_defaults_anyscale_filestore_ip_addresses" {
  description = "All Defaults - Anyscale Fileshare IP Addresses"
  value       = module.all_defaults.anyscale_filestore_ip_addresses
}
output "all_defaults_anyscale_filestore_location" {
  description = "All Defaults - Anyscale Filestore Location"
  value       = module.all_defaults.anyscale_filestore_location
}

# -------------------------------------------
# Kitchen Sink Test
# -------------------------------------------
output "kitchen_sink_anyscale_filestore_id" {
  description = "All Defaults - Anyscale Filestore ID"
  value       = module.kitchen_sink.anyscale_filestore_id
}
output "kitchen_sink_anyscale_filestore_name" {
  description = "All Defaults - Anyscale Filestore Name"
  value       = module.kitchen_sink.anyscale_filestore_name
}
output "kitchen_sink_anyscale_filestore_fileshare_name" {
  description = "All Defaults - Anyscale Fileshare Name"
  value       = module.kitchen_sink.anyscale_filestore_fileshare_name
}
output "kitchen_sink_anyscale_filestore_fileshare_source_backup" {
  description = "All Defaults - Anyscale Fileshare Source Backup"
  value       = module.kitchen_sink.anyscale_filestore_fileshare_source_backup
}
output "kitchen_sink_anyscale_filestore_ip_addresses" {
  description = "All Defaults - Anyscale Fileshare IP Addresses"
  value       = module.kitchen_sink.anyscale_filestore_ip_addresses
}
output "kitchen_sink_anyscale_filestore_location" {
  description = "All Defaults - Anyscale Filestore Location"
  value       = module.kitchen_sink.anyscale_filestore_location
}

# -----------------
# No resource test
# -----------------
output "test_no_resources" {
  description = "The outputs of the no_resource resource - should be empty"
  value       = module.test_no_resources
}
