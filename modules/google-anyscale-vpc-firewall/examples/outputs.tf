# -----------------------------------------------------
# All Defaults Test
# -----------------------------------------------------
output "all_defaults_name" {
  description = "all_defaults name"
  value       = module.all_defaults.vpc_firewall_policy_name
}
output "all_defualts_id" {
  description = "all_defaults id"
  value       = module.all_defaults.vpc_firewall_policy_id
}
output "all_defaults_selflink" {
  description = "all_defaults self link"
  value       = module.all_defaults.vpc_firewall_policy_selflink
}

# -----------------------------------------------------
# Kitchen Sink Test
# -----------------------------------------------------
output "kitchen_sink_name" {
  description = "kitchen_sink name"
  value       = module.kitchen_sink.vpc_firewall_policy_name
}
output "kitchen_sink_id" {
  description = "kitchen_sink id"
  value       = module.kitchen_sink.vpc_firewall_policy_id
}
output "kitchen_sink_selflink" {
  description = "kitchen_sink self link"
  value       = module.kitchen_sink.vpc_firewall_policy_selflink
}

# -----------------
# No resource test
# -----------------
output "test_no_resources" {
  description = "The outputs of the no_resource resource - should be empty"
  value       = module.test_no_resources
}
