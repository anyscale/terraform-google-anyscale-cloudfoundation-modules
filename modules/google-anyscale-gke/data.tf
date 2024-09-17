data "google_client_config" "current" {}

data "google_compute_zones" "available" {
  count = local.gke_zone_count == 0 ? 1 : 0
}

/******************************************
  Get available container engine versions
 *****************************************/
data "google_container_engine_versions" "region" {}

data "google_container_engine_versions" "zone" {
  location = local.gke_zone_count == 0 ? data.google_compute_zones.available[0].names[0] : var.gke_zones[0]
}
