output "registration_command" {
  description = "The Anyscale registration command."
  value       = <<-EOT
    anyscale cloud register --provider gcp \
    --name <anyscale_cloud_name> \
    --project-id ${module.google_anyscale_v2_privatenetwork.project_name} \
    --vpc-name ${module.google_anyscale_v2_privatenetwork.vpc_name} \
    --subnet-names ${module.google_anyscale_v2_privatenetwork.private_subnet_name} \
    --region ${module.google_anyscale_v2_privatenetwork.private_subnet_region} \
    --firewall-policy-names ${module.google_anyscale_v2_privatenetwork.vpc_firewall_policy_name} \
    --cloud-storage-bucket-name ${module.google_anyscale_v2_privatenetwork.cloudstorage_bucket_name} \
    --filestore-instance-id ${module.google_anyscale_v2_privatenetwork.filestore_name} \
    --filestore-location ${module.google_anyscale_v2_privatenetwork.filestore_location} \
    --anyscale-service-account-email ${module.google_anyscale_v2_privatenetwork.iam_anyscale_access_service_acct_email} \
    --instance-service-account-email ${module.google_anyscale_v2_privatenetwork.iam_anyscale_cluster_node_service_acct_email} \
    --provider-name ${module.google_anyscale_v2_privatenetwork.iam_workload_identity_provider_name} \
    --memorystore-instance-name ${module.google_anyscale_v2_privatenetwork.memorystore_id} \
    --private-network
  EOT
}
#
