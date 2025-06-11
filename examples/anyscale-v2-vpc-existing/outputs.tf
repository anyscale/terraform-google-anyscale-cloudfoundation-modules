output "registration_command" {
  description = "The Anyscale registration command."
  value       = <<-EOT
    anyscale cloud register --provider gcp \
    --name <anyscale_cloud_name> \
    --project-id ${var.existing_project_id} \
    --vpc-name ${var.existing_vpc_name} \
    --subnet-names ${var.existing_vpc_subnet_name} \
    --region ${var.anyscale_google_region} \
    --firewall-policy-names ${var.existing_firewall_policy_name} \
    --cloud-storage-bucket-name ${module.google_anyscale_v2_vpc_existing.cloudstorage_bucket_name} \
    --filestore-instance-id ${module.google_anyscale_v2_vpc_existing.filestore_name} \
    --filestore-location ${module.google_anyscale_v2_vpc_existing.filestore_location} \
    --anyscale-service-account-email ${module.google_anyscale_v2_vpc_existing.iam_anyscale_access_service_acct_email} \
    --instance-service-account-email ${module.google_anyscale_v2_vpc_existing.iam_anyscale_cluster_node_service_acct_email} \
    --provider-name ${module.google_anyscale_v2_vpc_existing.iam_workload_identity_provider_name} \
    --private-network
  EOT
}
