# --------------
# Defaults GKE Standard Cluster Test
# --------------
output "gke_standard_autoscaling_cluster_id" {
  description = "The ID of the all defaults anyscale resource."
  value       = module.gke_standard_autoscaling.anyscale_gke_cluster_id
}
output "gke_standard_autoscaling_cluster_name" {
  description = "The name of the anyscale resource."
  value       = module.gke_standard_autoscaling.anyscale_gke_cluster_name
}

output "gke_standard_autoscaling_cluster_endpoint" {
  description = "The endpoint of the anyscale resource."
  value       = module.gke_standard_autoscaling.anyscale_gke_cluster_endpoint
}

# --------------
# GKE Standard No Autoscaling Cluster Test
# --------------
output "standard_gke_no_autoscaling_outputs" {
  description = "The outputs from the standard_gke_no_autoscaling example."
  value       = module.standard_gke_no_autoscaling
}

# --------------
# GKE Autopilot Test
# --------------
output "autopilot_gke" {
  description = "The outputs from the standard_gke_no_autoscaling example."
  value       = module.autopilot_gke_iam
}

# -----------------
# No resource test
# -----------------
output "test_no_resources" {
  description = "The outputs of the no_resource resource - should all be empty"
  value       = module.test_no_resources
}
