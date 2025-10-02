output "vpc_name" {
  description = "The Google VPC network name."
  value       = module.google_anyscale_v2.vpc_name
}
output "subnet_name" {
  description = "The Google VPC public subnet name."
  value       = module.google_anyscale_v2.public_subnet_name
}
output "subnet_region" {
  description = "The Google VPC public subnet region."
  value       = module.google_anyscale_v2.public_subnet_region
}

output "firewall_policy_name" {
  description = "The Google VPC firewall policy name."
  value       = module.google_anyscale_v2.vpc_firewall_policy_name
}
output "cloudstorage_bucket_name" {
  description = "The Google Cloud Storage bucket name."
  value       = module.google_anyscale_v2.cloudstorage_bucket_name
}

output "project_name" {
  description = "The Google Project name."
  value       = module.google_anyscale_v2.project_name
}

output "filestore_instance_id" {
  description = "The Google Filestore instance id."
  value       = module.google_anyscale_v2.filestore_name
}
output "filestore_location" {
  description = "The Google Filestore location."
  value       = module.google_anyscale_v2.filestore_location
}

output "anyscale_iam_service_account_email" {
  description = "The Anyscale service account email."
  value       = module.google_anyscale_v2.iam_anyscale_access_service_acct_email
}

output "anyscale_iam_cluster_node_service_account_email" {
  description = "The Anyscale cluster service account email."
  value       = module.google_anyscale_v2.iam_anyscale_cluster_node_service_acct_email
}

output "anyscale_iam_workload_identity_provider_id" {
  description = "The Anyscale workload identity provider id."
  value       = module.google_anyscale_v2.iam_workload_identity_provider_id
}
output "anyscale_iam_workload_identity_provider_name" {
  description = "The Anyscale workload identity provider name."
  value       = module.google_anyscale_v2.iam_workload_identity_provider_name
}

output "registration_command" {
  description = "The Anyscale registration command."
  value       = <<-EOT
    anyscale cloud register --provider gcp \
    --name <anyscale_cloud_name> \
    --project-id ${module.google_anyscale_v2.project_name} \
    --vpc-name ${module.google_anyscale_v2.vpc_name} \
    --subnet-names ${module.google_anyscale_v2.public_subnet_name} \
    --region ${module.google_anyscale_v2.public_subnet_region} \
    --firewall-policy-names ${module.google_anyscale_v2.vpc_firewall_policy_name} \
    --cloud-storage-bucket-name ${module.google_anyscale_v2.cloudstorage_bucket_name} \
    --filestore-instance-id ${module.google_anyscale_v2.filestore_name} \
    --filestore-location ${module.google_anyscale_v2.filestore_location} \
    --anyscale-service-account-email ${module.google_anyscale_v2.iam_anyscale_access_service_acct_email} \
    --instance-service-account-email ${module.google_anyscale_v2.iam_anyscale_cluster_node_service_acct_email} \
    --provider-name ${module.google_anyscale_v2.iam_workload_identity_provider_name}
  EOT
}

output "anyscale_cloud_resource_yaml" {
  description = <<-EOF
    Anyscale cloud resource YAML configuration for Google Cloud Platform with shared VPC.
    This output can be saved to a file and used with `anyscale cloud resource create` command.
    The name is auto-generated as vm-gcp-$${var.anyscale_google_region} but can be updated in the YAML file if needed.
  EOF
  value = <<-EOT
name: vm-gcp-${var.anyscale_google_region}
provider: GCP
compute_stack: VM
region: ${var.anyscale_google_region}
networking_mode: PUBLIC
object_storage:
  bucket_name: gs://${module.google_anyscale_v2.cloudstorage_bucket_name}
file_storage:
  file_storage_id: projects/${module.google_anyscale_v2.project_name}/locations/${module.google_anyscale_v2.filestore_location}/instances/${module.google_anyscale_v2.filestore_name}
gcp_config:
  project_id: ${module.google_anyscale_v2.project_name}
  vpc_name: ${module.google_anyscale_v2.vpc_name}
  subnet_names:
    - ${module.google_anyscale_v2.public_subnet_name}
  firewall_policy_names:
    - ${module.google_anyscale_v2.vpc_firewall_policy_name}
  anyscale_service_account_email: ${module.google_anyscale_v2.iam_anyscale_access_service_acct_email}
  cluster_service_account_email: ${module.google_anyscale_v2.iam_anyscale_cluster_node_service_acct_email}
  provider_name: ${module.google_anyscale_v2.iam_workload_identity_provider_name}
EOT
}
#
