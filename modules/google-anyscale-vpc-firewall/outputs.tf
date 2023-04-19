output "vpc_firewall_policy_name" {
  description = "The Google VPC firewall policy name."
  value       = try(google_compute_network_firewall_policy.anyscale_firewall_policy[0].name, "")
}

output "vpc_firewall_policy_id" {
  description = "The Google VPC firewall policy id."
  value       = try(google_compute_network_firewall_policy.anyscale_firewall_policy[0].id, "")
}

output "vpc_firewall_policy_selflink" {
  description = "The Google VPC firewall policy self link."
  value       = try(google_compute_network_firewall_policy.anyscale_firewall_policy[0].self_link, "")
}

output "vpc_firewall_policy_selflink_withid" {
  description = "The Google VPC firewall policy self link with id."
  value       = try(google_compute_network_firewall_policy.anyscale_firewall_policy[0].self_link_with_id, "")
}

output "vpc_firewall_policy_networkfirewallpolicyid" {
  description = "The Google VPC firewall policy network firewall policy id."
  value       = try(google_compute_network_firewall_policy.anyscale_firewall_policy[0].network_firewall_policy_id, "")
}
