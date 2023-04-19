# -------------------------------------------
# Anyscale Filestore
# -------------------------------------------
output "anyscale_filestore_id" {
  description = "Anyscale filestore ID"
  value       = try(google_filestore_instance.anyscale[0].id, null)
}

output "anyscale_filestore_name" {
  description = "Anyscale filestore name"
  value       = try(google_filestore_instance.anyscale[0].name, null)
}

output "anyscale_filestore_fileshare_name" {
  description = "Anyscale filestore fileshare name"
  value       = try(google_filestore_instance.anyscale[0].file_shares[0].name, null)
}

output "anyscale_filestore_fileshare_source_backup" {
  description = "Anyscale filestore fileshare source backup"
  value       = try(google_filestore_instance.anyscale[0].file_shares[0].source_backup, null)
}

output "anyscale_filestore_ip_addresses" {
  description = "Anyscale filestore IP addresses"
  value       = try(google_filestore_instance.anyscale[0].networks[0].ip_addresses, null)
}

output "anyscale_filestore_location" {
  description = "Anyscale filestore location"
  value       = try(google_filestore_instance.anyscale[0].location, null)
}
