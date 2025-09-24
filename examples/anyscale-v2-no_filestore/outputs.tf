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
  bucket_name: gs://${module.google_anyscale_v2_commonname.cloudstorage_bucket_name}
gcp_config:
  project_id: ${module.google_anyscale_v2_commonname.project_name}
  vpc_name: ${module.google_anyscale_v2_commonname.vpc_name}
  subnet_names:
    - ${module.google_anyscale_v2_commonname.public_subnet_name}
  firewall_policy_names:
    - ${module.google_anyscale_v2_commonname.vpc_firewall_policy_name}
  anyscale_service_account_email: ${module.google_anyscale_v2_commonname.iam_anyscale_access_service_acct_email}
  cluster_service_account_email: ${module.google_anyscale_v2_commonname.iam_anyscale_cluster_node_service_acct_email}
  provider_name: ${module.google_anyscale_v2_commonname.iam_workload_identity_provider_name}
EOT
}
#

output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.google_anyscale_v2_commonname.vpc_id
}
