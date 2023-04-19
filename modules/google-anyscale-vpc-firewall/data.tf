data "google_compute_network" "anyscale_vpc" {
  count   = var.module_enabled ? 1 : 0
  project = var.anyscale_project_id

  name = var.vpc_name
}
