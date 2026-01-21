data "google_client_config" "current" {}

data "google_compute_subnetwork" "existing_vpc_subnet" {
  count   = local.execute_vpc_firewall_sub_module && var.existing_vpc_subnet_name != null && var.existing_vpc_name != null && var.existing_project_id != null && var.shared_vpc_project_id == null ? 1 : 0
  project = var.existing_project_id

  name = var.existing_vpc_subnet_name
}

data "google_compute_subnetwork" "shared_vpc_subnet" {
  count   = local.execute_vpc_firewall_sub_module && var.existing_vpc_subnet_name != null && var.existing_vpc_name != null && var.shared_vpc_project_id != null ? 1 : 0
  project = var.shared_vpc_project_id

  name = var.existing_vpc_subnet_name
}

data "google_compute_network" "existing_vpc" {
  count   = local.execute_vpc_firewall_sub_module && var.existing_vpc_name != null && var.existing_vpc_id == null && var.existing_project_id != null && var.shared_vpc_project_id == null ? 1 : 0
  project = var.existing_project_id
  name    = var.existing_vpc_name
}

data "google_compute_network" "shared_vpc" {
  count   = local.execute_vpc_firewall_sub_module && var.existing_vpc_name != null && var.existing_vpc_id == null && var.shared_vpc_project_id != null ? 1 : 0
  project = var.shared_vpc_project_id
  name    = var.existing_vpc_name
}
