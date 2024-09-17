# -------------------------------------------
# Anyscale GKE Cluster
# -------------------------------------------

output "anyscale_gke_cluster_id" {
  description = "Anyscale GKE Cluster ID"
  value       = try(google_container_cluster.anyscale_dataplane[0].id, null)
}

output "anyscale_gke_cluster_name" {
  description = "Anyscale GKE Cluster name"
  value       = try(google_container_cluster.anyscale_dataplane[0].name, null)
}

output "anyscale_gke_cluster_endpoint" {
  description = "Anyscale GKE Cluster endpoint"
  value       = try(google_container_cluster.anyscale_dataplane[0].endpoint, null)
}

output "anyscale_gke_cluster_master_version" {
  description = "Anyscale GKE Cluster master version"
  value       = try(google_container_cluster.anyscale_dataplane[0].master_version, null)
}
