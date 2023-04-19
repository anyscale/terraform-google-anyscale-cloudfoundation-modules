output "vpc_name" {
  description = "The Google VPC network name."
  value       = module.google_anyscale_v2_existingproject.vpc_name
}
output "subnet_name" {
  description = "The Google VPC public subnet name."
  value       = module.google_anyscale_v2_existingproject.public_subnet_name
}
output "subnet_region" {
  description = "The Google VPC public subnet region."
  value       = module.google_anyscale_v2_existingproject.public_subnet_region
}

output "firewall_policy_name" {
  description = "The Google VPC firewall policy name."
  value       = module.google_anyscale_v2_existingproject.vpc_firewall_policy_name
}
output "cloudstorage_bucket_name" {
  description = "The Google Cloud Storage bucket name."
  value       = module.google_anyscale_v2_existingproject.cloudstorage_bucket_name
}

output "project_name" {
  description = "The Google Project name."
  value       = module.google_anyscale_v2_existingproject.project_name
}

output "filestore_instance_id" {
  description = "The Google Filestore instance id."
  value       = module.google_anyscale_v2_existingproject.filestore_name
}
output "filestore_location" {
  description = "The Google Filestore location."
  value       = module.google_anyscale_v2_existingproject.filestore_location
}

output "anyscale_iam_service_account_email" {
  description = "The Anyscale service account email."
  value       = module.google_anyscale_v2_existingproject.iam_anyscale_access_role_email
}

output "anyscale_iam_cluster_node_role_email" {
  description = "The Anyscale cluster service account email."
  value       = module.google_anyscale_v2_existingproject.iam_anyscale_cluster_node_role_email
}

output "anyscale_iam_workload_identity_provider_id" {
  description = "The Anyscale workload identity provider id."
  value       = module.google_anyscale_v2_existingproject.iam_workload_identity_provider_id
}
output "anyscale_iam_workload_identity_provider_name" {
  description = "The Anyscale workload identity provider name."
  value       = module.google_anyscale_v2_existingproject.iam_workload_identity_provider_name
}

output "registration_command" {
  description = "The Anyscale registration command."
  value       = "anyscale cloud register --provider gcp \\\n--name <anyscale_cloud_name> \\\n--project-id ${var.existing_project_id} \\\n--vpc-name ${module.google_anyscale_v2_existingproject.vpc_name} \\\n--subnet-names ${module.google_anyscale_v2_existingproject.public_subnet_name} \\\n--region ${module.google_anyscale_v2_existingproject.public_subnet_region} \\\n--firewall-policy-names ${module.google_anyscale_v2_existingproject.vpc_firewall_policy_name} \\\n--cloud-storage-bucket-name ${module.google_anyscale_v2_existingproject.cloudstorage_bucket_name} \\\n--filestore-instance-id ${module.google_anyscale_v2_existingproject.filestore_name} \\\n--filestore-location ${module.google_anyscale_v2_existingproject.filestore_location} \\\n--anyscale-service-account-email ${module.google_anyscale_v2_existingproject.iam_anyscale_access_role_email} \\\n--instance-service-account-email ${module.google_anyscale_v2_existingproject.iam_anyscale_cluster_node_role_email} \\\n--provider-id ${module.google_anyscale_v2_existingproject.iam_workload_identity_provider_name}"
}
#
