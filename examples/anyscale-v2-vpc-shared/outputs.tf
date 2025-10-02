output "registration_command" {
  description = "The Anyscale registration command."
  value       = <<-EOT
    anyscale cloud register --provider gcp \
    --name <anyscale_cloud_name> \
    --project-id ${var.existing_project_id} \
    --vpc-name ${var.existing_vpc_name} \
    --subnet-names ${var.existing_vpc_subnet_name} \
    --region ${var.anyscale_google_region} \
    --firewall-policy-names ${module.google_anyscale_v2_vpc_shared.vpc_firewall_policy_name} \
    --cloud-storage-bucket-name ${module.google_anyscale_v2_vpc_shared.cloudstorage_bucket_name} \
    --filestore-instance-id ${module.google_anyscale_v2_vpc_shared.filestore_name} \
    --filestore-location ${module.google_anyscale_v2_vpc_shared.filestore_location} \
    --anyscale-service-account-email ${module.google_anyscale_v2_vpc_shared.iam_anyscale_access_service_acct_email} \
    --instance-service-account-email ${module.google_anyscale_v2_vpc_shared.iam_anyscale_cluster_node_service_acct_email} \
    --provider-name ${module.google_anyscale_v2_vpc_shared.iam_workload_identity_provider_name} \
    --host-project-id ${var.shared_vpc_project_id}
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
  bucket_name: gs://${module.google_anyscale_v2_vpc_shared.cloudstorage_bucket_name}
file_storage:
  file_storage_id: projects/${var.existing_project_id}/locations/${module.google_anyscale_v2_vpc_shared.filestore_location}/instances/${module.google_anyscale_v2_vpc_shared.filestore_name}
gcp_config:
  project_id: ${var.existing_project_id}
  vpc_name: ${var.existing_vpc_name}
  subnet_names:
    - ${var.existing_vpc_subnet_name}
  firewall_policy_names:
    - ${module.google_anyscale_v2_vpc_shared.vpc_firewall_policy_name}
  anyscale_service_account_email: ${module.google_anyscale_v2_vpc_shared.iam_anyscale_access_service_acct_email}
  cluster_service_account_email: ${module.google_anyscale_v2_vpc_shared.iam_anyscale_cluster_node_service_acct_email}
  provider_name: ${module.google_anyscale_v2_vpc_shared.iam_workload_identity_provider_name}
  host_project_id: ${var.shared_vpc_project_id}
EOT
}
