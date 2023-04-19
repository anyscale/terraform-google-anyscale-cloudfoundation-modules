locals {
  # intermediate locals
  # default_name                   = "cloud-nat-${random_string.name_suffix.result}"
  # nat_ips_length                 = length(var.nat_ips)
  # default_nat_ip_allocate_option = local.nat_ips_length > 0 ? "MANUAL_ONLY" : "AUTO_ONLY"
  # # locals for google_compute_router_nat
  # nat_ip_allocate_option = var.nat_ip_allocate_option ? var.nat_ip_allocate_option : local.default_nat_ip_allocate_option
  # name                   = var.name != "" ? var.name : local.default_name
  create_nat_enabled   = var.module_enabled && var.private_subnet_cidr != null && var.create_nat ? true : false
  computed_router_name = coalesce(var.router_name, "${local.computed_anyscale_vpcname}-router")
  computed_nat_name    = coalesce(var.nat_name, "${local.computed_anyscale_vpcname}-nat")
}

resource "google_compute_router" "router" {
  count = local.create_nat_enabled ? 1 : 0

  name    = local.computed_router_name
  project = var.anyscale_project_id
  region  = var.google_region
  network = google_compute_network.anyscale_vpc[0].name
  bgp {
    asn                = var.router_asn
    keepalive_interval = var.router_keepalive_interval
  }
}

resource "google_compute_router_nat" "main" {
  count = local.create_nat_enabled ? 1 : 0

  project                = var.anyscale_project_id
  region                 = var.google_region
  name                   = local.computed_nat_name
  router                 = google_compute_router.router[0].name
  nat_ip_allocate_option = "AUTO_ONLY"
  # nat_ips                             = var.nat_ips
  source_subnetwork_ip_ranges_to_nat  = var.source_subnetwork_ip_ranges_to_nat
  min_ports_per_vm                    = var.nat_min_ports_per_vm
  enable_endpoint_independent_mapping = var.nat_enable_endpoint_independent_mapping

  udp_idle_timeout_sec             = var.nat_udp_idle_timeout_sec
  icmp_idle_timeout_sec            = var.nat_icmp_idle_timeout_sec
  tcp_established_idle_timeout_sec = var.nat_tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec  = var.nat_tcp_transitory_idle_timeout_sec
  tcp_time_wait_timeout_sec        = var.nat_tcp_time_wait_timeout_sec

  dynamic "subnetwork" {
    for_each = var.source_subnetwork_ip_ranges_to_nat == "LIST_OF_SUBNETWORKS" ? [1] : []
    content {
      name                    = google_compute_subnetwork.anyscale_private_subnet[0].name
      source_ip_ranges_to_nat = toset([var.private_subnet_cidr])
    }
  }

  dynamic "log_config" {
    for_each = var.nat_enable_logging == true ? [{
      enable = var.nat_enable_logging
      filter = var.nat_log_config_filter
    }] : []

    content {
      enable = log_config.value.enable
      filter = log_config.value.filter
    }
  }
}
