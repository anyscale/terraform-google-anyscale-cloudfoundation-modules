output "project_name" {
  description = "Name of the project"
  value       = try(google_project.anyscale_project[0].name, "")
}

output "project_id" {
  description = "ID of the project"
  value       = try(google_project.anyscale_project[0].project_id, "")
}

output "project_number" {
  description = "Numeric identifier for the project"
  value       = try(google_project.anyscale_project[0].number, "")
}
