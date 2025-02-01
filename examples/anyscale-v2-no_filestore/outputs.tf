output "registration_command" {
  description = "The Anyscale registration command."
  value       = <<-EOT
    anyscale cloud register --provider gcp \
    --name <anyscale_cloud_name> \
    --project-id ${module.google_anyscale_v2_commonname.project_name} \
    --vpc-name ${module.google_anyscale_v2_commonname.vpc_name} \
    --subnet-names ${module.google_anyscale_v2_commonname.public_subnet_name} \
    --region ${module.google_anyscale_v2_commonname.public_subnet_region} \
    --firewall-policy-names ${module.google_anyscale_v2_commonname.vpc_firewall_policy_name} \
    --cloud-storage-bucket-name ${module.google_anyscale_v2_commonname.cloudstorage_bucket_name} \
    --anyscale-service-account-email ${module.google_anyscale_v2_commonname.iam_anyscale_access_service_acct_email} \
    --instance-service-account-email ${module.google_anyscale_v2_commonname.iam_anyscale_cluster_node_service_acct_email} \
    --provider-name ${module.google_anyscale_v2_commonname.iam_workload_identity_provider_name}
  EOT
}
#

output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.google_anyscale_v2_commonname.vpc_id
}
