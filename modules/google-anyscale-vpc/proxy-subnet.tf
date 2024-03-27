# ----------------
# Proxy Subnets
# ----------------
locals {
  proxy_subnet_enabled = var.proxy_subnet_cidr != null && var.module_enabled ? true : false

  proxy_subnet_name_computed = coalesce(
    var.proxy_subnet_name,
    "${local.computed_anyscale_vpcname}-${local.google_region}-${var.proxy_subnet_suffix}"
  )
}

#tfsec:ignore:google-compute-enable-vpc-flow-logs:VPC Flow Logs can be disabled but are enabled by default.
resource "google_compute_subnetwork" "anyscale_proxy_subnet" {
  #checkov:skip=CKV_GCP_74:Private IP Google Access disabled for Proxy Subnets per Google Documentation
  #checkov:skip=CKV_GCP_76:Private Google Access disabled for Proxy Subnets per Google Documentation
  #checkov:skip=CKV_GCP_26:VPC Flow Logs disabled for Proxy Subnets
  count = local.proxy_subnet_enabled ? 1 : 0

  name          = local.proxy_subnet_name_computed
  ip_cidr_range = var.proxy_subnet_cidr
  region        = var.google_region

  network     = google_compute_network.anyscale_vpc[0].name
  project     = var.anyscale_project_id
  description = var.proxy_subnet_description

  purpose = "REGIONAL_MANAGED_PROXY"
  role    = "ACTIVE"
}
