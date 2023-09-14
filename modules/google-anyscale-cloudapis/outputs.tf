# -------------------------------------------
# Anyscale APIs
# -------------------------------------------
output "enabled_apis" {
  description = "Enabled APIs in the project"
  value       = try([for api in google_project_service.anyscale_required_apis : api.service], "")
}

# output "enabled_api_identities" {
#   description = "Enabled API identities in the project"
#   value       = try({ for i in google_project_service_identity.anyscale_service_identities : i.service => i.email }, "")
# }
