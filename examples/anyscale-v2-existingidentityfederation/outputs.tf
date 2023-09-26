output "registration_command" {
  description = "The Anyscale registration command."
  value       = <<-EOT
    anyscale cloud register --provider gcp \
    --name <anyscale_cloud_name> \
    --project-id ${module.google_anyscale_v2_existingidentityfederation.project_name} \
    --vpc-name ${module.google_anyscale_v2_existingidentityfederation.vpc_name} \
    --subnet-names ${module.google_anyscale_v2_existingidentityfederation.public_subnet_name} \
    --region ${module.google_anyscale_v2_existingidentityfederation.public_subnet_region} \
    --firewall-policy-names ${module.google_anyscale_v2_existingidentityfederation.vpc_firewall_policy_name} \
    --cloud-storage-bucket-name ${module.google_anyscale_v2_existingidentityfederation.cloudstorage_bucket_name} \
    --filestore-instance-id ${module.google_anyscale_v2_existingidentityfederation.filestore_name} \
    --filestore-location ${module.google_anyscale_v2_existingidentityfederation.filestore_location} \
    --anyscale-service-account-email ${module.google_anyscale_v2_existingidentityfederation.iam_anyscale_access_role_email} \
    --instance-service-account-email ${module.google_anyscale_v2_existingidentityfederation.iam_anyscale_cluster_node_role_email} \
    --provider-name ${var.existing_workload_identity_provider_name}
  EOT
}
#
