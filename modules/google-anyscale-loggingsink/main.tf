locals {
  project_id = coalesce(var.anyscale_project_id, data.google_client_config.current.project)

  sink_destination      = var.sink_destination != null ? var.sink_destination : "logging.googleapis.com/projects/${local.project_id}/locations/global/buckets/_Default"
  sink_exclusion_filter = var.sink_exclusion_filter != null ? var.sink_exclusion_filter : "resource.type=gce_instance AND logName=\"projects/${local.project_id}/logs/syslog\" "
}

# Update the _Default Logging Sink to disable syslog being sent to the default bucket
resource "google_logging_project_sink" "default" {
  count = var.module_enabled ? 1 : 0

  name        = "_Default"
  destination = local.sink_destination

  exclusions {
    name        = "anyscale"
    description = "Exclude syslog files from Anyscale clusters"
    filter      = local.sink_exclusion_filter
  }
  unique_writer_identity = true

  project = var.anyscale_project_id

}
