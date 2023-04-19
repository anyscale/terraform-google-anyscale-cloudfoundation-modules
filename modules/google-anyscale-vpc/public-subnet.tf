# ----------------
# Public Subnets
# ----------------
locals {
  public_subnet_enabled = var.public_subnet_cidr != null && var.existing_public_subnet_id == null ? true : false

  public_subnet_flow_log_enabled = length(var.public_subnet_flow_log_config) > 0 ? true : false
  # existing_prv_rt_count = length(var.existing_public_route_table_ids) > 0 ? length(var.existing_public_route_table_ids) : 0
  public_subnet_name_computed = coalesce(
    var.public_subnet_name,
    format("${local.computed_anyscale_vpcname}-${local.google_region}-${var.public_subnet_suffix}")
  )
  # public_route_table_ids = local.existing_prv_rt_count > 0 ? var.existing_public_route_table_ids : local.public_subnet_count > 0 ? aws_route_table.public[*].id : []
}

#tfsec:ignore:google-compute-enable-vpc-flow-logs:VPC Flow Logs can be disabled but are enabled by default.
resource "google_compute_subnetwork" "anyscale_public_subnet" {
  count = var.module_enabled && local.public_subnet_enabled ? 1 : 0

  name                     = local.public_subnet_name_computed
  ip_cidr_range            = var.public_subnet_cidr
  region                   = var.google_region
  private_ip_google_access = var.public_subnet_google_api_access
  dynamic "log_config" {
    for_each = local.public_subnet_flow_log_enabled ? [true] : []
    content {
      aggregation_interval = lookup(var.public_subnet_flow_log_config, "subnet_flow_logs_interval", "INTERVAL_5_SEC")
      flow_sampling        = lookup(var.public_subnet_flow_log_config, "subnet_flow_logs_sampling", "0.5")
      metadata             = lookup(var.public_subnet_flow_log_config, "subnet_flow_logs_metadata", "INCLUDE_ALL_METADATA")
      filter_expr          = lookup(var.public_subnet_flow_log_config, "subnet_flow_logs_filter", "true")
    }
  }
  network     = google_compute_network.anyscale_vpc[0].name
  project     = var.anyscale_project_id
  description = var.public_subnet_description

  # purpose          = lookup(each.value, "purpose", null)
  # role             = lookup(each.value, "role", null)
  stack_type       = var.public_subnet_stack_type
  ipv6_access_type = var.public_subnet_ipv6_type
}
