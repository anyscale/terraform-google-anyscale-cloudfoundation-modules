# ----------------
# Firewalls
# ----------------
locals {
  firewall_policyname_computed = coalesce(var.firewall_policy_name, var.vpc_name, "anyscale-firewall-policy")

  ingress_with_self_enabled        = var.module_enabled && length(var.ingress_with_self_map) > 0 && length(var.ingress_with_self_cidr_range) > 0 ? true : false
  ingress_from_cidr_blocks_enabled = var.module_enabled && var.ingress_from_cidr_map != null && length(var.ingress_from_cidr_map) > 0 ? true : false
  ingress_from_gcp_health_checks   = var.module_enabled && var.ingress_from_gcp_health_checks != null ? true : false
}

#-------------------------------
# Random Strings for Name
#-------------------------------
# resource "random_id" "random_char_suffix" {
#   count = local.random_id_enabled ? 1 : 0

#   byte_length = local.random_char_length
# }

# ----------------
# Firewall Policy
# ----------------
resource "google_compute_network_firewall_policy" "anyscale_firewall_policy" {
  count   = var.module_enabled ? 1 : 0
  project = var.anyscale_project_id

  name        = local.firewall_policyname_computed
  description = var.firewall_policy_description
}

resource "google_compute_network_firewall_policy_association" "anyscale_firewall_policy" {
  count   = var.module_enabled ? 1 : 0
  project = var.anyscale_project_id

  name              = "${var.vpc_name}-association"
  attachment_target = data.google_compute_network.anyscale_vpc[0].self_link
  firewall_policy   = google_compute_network_firewall_policy.anyscale_firewall_policy[0].name
}

# ----------------
# Ingress Rules
# ----------------
resource "google_compute_network_firewall_policy_rule" "ingress_with_self" {
  count   = local.ingress_with_self_enabled ? length(var.ingress_with_self_map) : 0
  project = var.anyscale_project_id

  description     = "Internal Ingress Rule"
  direction       = "INGRESS"
  action          = "allow"
  enable_logging  = var.enable_firewall_rule_logging
  firewall_policy = google_compute_network_firewall_policy.anyscale_firewall_policy[0].name

  priority = lookup(
    var.ingress_with_self_map[count.index],
    "priority",
    count.index + 100
  )

  match {
    src_ip_ranges = split(
      ",",
      lookup(
        var.ingress_with_self_map[count.index],
        "cidr_blocks",
        join(",", var.ingress_with_self_cidr_range)
      )
    )
    layer4_configs {
      ip_protocol = lookup(
        var.ingress_with_self_map[count.index],
        "protocol",
        try(
          var.predefined_firewall_rules[lookup(var.ingress_with_self_map[count.index], "rule", "_")][1],
          "tcp"
        )
      )
      ports = var.predefined_firewall_rules[lookup(var.ingress_with_self_map[count.index], "rule", "_")][0] == "" ? null : tolist([
        lookup(
          var.ingress_with_self_map[count.index],
          "ports",
          try(
            var.predefined_firewall_rules[lookup(var.ingress_with_self_map[count.index], "rule", "_")][0],
            null
          )
        )
      ])
    }
  }
}

resource "google_compute_network_firewall_policy_rule" "ingress_allow_from_cidr_blocks" {
  count   = local.ingress_from_cidr_blocks_enabled ? length(var.ingress_from_cidr_map) : 0
  project = var.anyscale_project_id

  # name        = "${local.computed_anyscale_vpcname}-ingress-allow-from-cidr-blocks-${count.index}"
  description     = lookup(var.ingress_from_cidr_map[count.index], "description", "Ingress Rule")
  direction       = "INGRESS"
  action          = "allow"
  enable_logging  = var.enable_firewall_rule_logging
  firewall_policy = google_compute_network_firewall_policy.anyscale_firewall_policy[0].name

  priority = lookup(
    var.ingress_from_cidr_map[count.index],
    "priority",
    try(
      var.predefined_firewall_rules[lookup(var.ingress_from_cidr_map[count.index], "rule", "_")][3],
      count.index
    )
  )

  match {
    src_ip_ranges = split(
      ",",
      lookup(
        var.ingress_from_cidr_map[count.index],
        "cidr_blocks",
        join(",", var.default_ingress_cidr_range)
      )
    )

    layer4_configs {
      ip_protocol = lookup(
        var.ingress_from_cidr_map[count.index],
        "protocol",
        try(
          var.predefined_firewall_rules[lookup(var.ingress_from_cidr_map[count.index], "rule", "_")][1],
          "tcp"
        )
      )
      ports = var.predefined_firewall_rules[lookup(var.ingress_from_cidr_map[count.index], "rule", "_")][0] == "" ? null : tolist([
        lookup(
          var.ingress_from_cidr_map[count.index],
          "ports",
          try(
            var.predefined_firewall_rules[lookup(var.ingress_from_cidr_map[count.index], "rule", "_")][0],
            null
          )
        )
      ])
    }
  }

}

resource "google_compute_network_firewall_policy_rule" "ingress_allow_from_gcp_health_checks" {
  count   = local.ingress_from_gcp_health_checks ? length(var.ingress_from_gcp_health_checks) : 0
  project = var.anyscale_project_id

  # name        = "${local.computed_anyscale_vpcname}-ingress-allow-from-cidr-blocks-${count.index}"
  description     = lookup(var.ingress_from_gcp_health_checks[count.index], "description", "Ingress Rule")
  direction       = "INGRESS"
  action          = "allow"
  enable_logging  = var.enable_firewall_rule_logging
  firewall_policy = google_compute_network_firewall_policy.anyscale_firewall_policy[0].name

  priority = lookup(
    var.ingress_from_gcp_health_checks[count.index],
    "priority",
    try(
      var.predefined_firewall_rules[lookup(var.ingress_from_gcp_health_checks[count.index], "rule", "_")][3],
      count.index
    )
  )

  match {
    src_ip_ranges = split(
      ",",
      lookup(
        var.ingress_from_gcp_health_checks[count.index],
        "cidr_blocks",
        join(",", var.default_ingress_cidr_range)
      )
    )

    layer4_configs {
      ip_protocol = lookup(
        var.ingress_from_gcp_health_checks[count.index],
        "protocol",
        try(
          var.predefined_firewall_rules[lookup(var.ingress_from_gcp_health_checks[count.index], "rule", "_")][1],
          "tcp"
        )
      )
      ports = var.predefined_firewall_rules[lookup(var.ingress_from_gcp_health_checks[count.index], "rule", "_")][0] == "" ? null : tolist([
        lookup(
          var.ingress_from_cidr_map[count.index],
          "ports",
          try(
            var.predefined_firewall_rules[lookup(var.ingress_from_gcp_health_checks[count.index], "rule", "_")][0],
            null
          )
        )
      ])
    }
  }

}
