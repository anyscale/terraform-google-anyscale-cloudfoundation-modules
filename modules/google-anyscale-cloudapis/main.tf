locals {
  # activate_compute_identity = 0 != length([for i in var.activate_api_identities : i if i.api == "compute.googleapis.com"])
  compute_enabled = contains(var.anyscale_activate_required_apis, "compute.googleapis.com") ? true : false
  required_apis   = var.module_enabled ? toset(concat(var.anyscale_activate_required_apis)) : toset([])
  optional_apis   = var.module_enabled && length(var.anyscale_activate_optional_apis) > 0 ? toset(var.anyscale_activate_optional_apis) : toset([])
  # api_identities = flatten([
  #   for i in var.activate_api_identities : [
  #     for r in i.roles :
  #     { api = i.api, role = r }
  #   ]
  # ])
}
# --------------------------------------------------------------
# Anyscale Google Cloud APIs Resource
# --------------------------------------------------------------
resource "google_project_service" "anyscale_required_apis" {
  for_each = {
    for i in local.required_apis :
    i => i
    if i != "compute.googleapis.com"
  }
  project                    = var.anyscale_project_id
  service                    = each.value
  disable_on_destroy         = var.disable_services_on_destroy
  disable_dependent_services = var.disable_dependent_services
}

resource "google_project_service" "anycale_compute_api" {
  count                      = local.compute_enabled ? 1 : 0
  project                    = var.anyscale_project_id
  service                    = "compute.googleapis.com"
  disable_on_destroy         = false
  disable_dependent_services = false
}

resource "google_project_service" "anyscale_optional_apis" {
  for_each = {
    for i in local.optional_apis :
    i => i
  }
  project                    = var.anyscale_project_id
  service                    = each.value
  disable_on_destroy         = var.disable_services_on_destroy
  disable_dependent_services = var.disable_dependent_services
}

# **************************************************
# With the current beta provider, the following does not work.
# **************************************************
# First handle all service identities EXCEPT compute.googleapis.com.
# resource "google_project_service_identity" "anyscale_service_identities" {
#   for_each = {
#     for i in var.activate_api_identities :
#     i.api => i
#     if i.api != "compute.googleapis.com"
#   }

#   provider = google-beta
#   project  = var.anyscale_project_id
#   service  = each.value.api
# }

# Process the compute.googleapis.com identity separately, if present in the inputs.
# data "google_compute_default_service_account" "default" {
#   count   = local.activate_compute_identity ? 1 : 0
#   project = var.anyscale_project_id
# }

# locals {
#   add_service_roles = merge(
#     {
#       for si in local.api_identities :
#       "${si.api} ${si.role}" => {
#         email = google_project_service_identity.anyscale_service_identities[si.api].email
#         role  = si.role
#       }
#       if si.api != "compute.googleapis.com"
#     },
#     {
#       for si in local.api_identities :
#       "${si.api} ${si.role}" => {
#         email = data.google_compute_default_service_account.default[0].email
#         role  = si.role
#       }
#       if si.api == "compute.googleapis.com"
#     }
#   )
# }

# resource "google_project_iam_member" "project_service_identity_roles" {
#   for_each = local.add_service_roles

#   project = var.anyscale_project_id
#   role    = each.value.role
#   member  = "serviceAccount:${each.value.email}"
# }
