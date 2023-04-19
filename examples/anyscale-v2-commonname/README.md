# anyscale-v2-commonname example

Builds the resources for Anyscale in a Google Cloud.
This example will build resources with a standard prefix and random suffix.
Creates a v2 stack including:
- Project
- Enabling Cloud APIs on the Project
- Cloud Storage Bucket - Standard
- IAM Roles
- VPC with publicly routed subnets (no internal)
- VPC Firewall
- FileStore

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_google_anyscale_v2_commonname"></a> [google\_anyscale\_v2\_commonname](#module\_google\_anyscale\_v2\_commonname) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID. Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_deploy_env"></a> [anyscale\_deploy\_env](#input\_anyscale\_deploy\_env) | (Required) Anyscale deploy environment. Used in resource names and tags. | `string` | n/a | yes |
| <a name="input_anyscale_google_region"></a> [anyscale\_google\_region](#input\_anyscale\_google\_region) | (Required) Google region to deploy Anyscale resources. | `string` | n/a | yes |
| <a name="input_anyscale_google_zone"></a> [anyscale\_google\_zone](#input\_anyscale\_google\_zone) | (Required) Google zone to deploy Anyscale resources. | `string` | n/a | yes |
| <a name="input_billing_account_id"></a> [billing\_account\_id](#input\_billing\_account\_id) | (Required) Google billing account ID to deploy Anyscale resources. | `string` | n/a | yes |
| <a name="input_customer_ingress_cidr_ranges"></a> [customer\_ingress\_cidr\_ranges](#input\_customer\_ingress\_cidr\_ranges) | The IPv4 CIDR blocks that allows access Anyscale clusters.<br>These are added to the firewall and allows port 443 (https) and 22 (ssh) access.<br>ex: `52.1.1.23/32,10.1.0.0/16'<br>` | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) A map of labels to all resources that accept labels. | `map(string)` | <pre>{<br>  "environment": "test",<br>  "test": true<br>}</pre> | no |
| <a name="input_root_project_id"></a> [root\_project\_id](#input\_root\_project\_id) | (Required) Google project ID to deploy Anyscale resources. Will create a new sub-project by default. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_anyscale_iam_cluster_node_role_email"></a> [anyscale\_iam\_cluster\_node\_role\_email](#output\_anyscale\_iam\_cluster\_node\_role\_email) | The Anyscale cluster service account email. |
| <a name="output_anyscale_iam_service_account_email"></a> [anyscale\_iam\_service\_account\_email](#output\_anyscale\_iam\_service\_account\_email) | The Anyscale service account email. |
| <a name="output_anyscale_iam_workload_identity_provider_id"></a> [anyscale\_iam\_workload\_identity\_provider\_id](#output\_anyscale\_iam\_workload\_identity\_provider\_id) | The Anyscale workload identity provider id. |
| <a name="output_anyscale_iam_workload_identity_provider_name"></a> [anyscale\_iam\_workload\_identity\_provider\_name](#output\_anyscale\_iam\_workload\_identity\_provider\_name) | The Anyscale workload identity provider name. |
| <a name="output_cloudstorage_bucket_name"></a> [cloudstorage\_bucket\_name](#output\_cloudstorage\_bucket\_name) | The Google Cloud Storage bucket name. |
| <a name="output_filestore_instance_id"></a> [filestore\_instance\_id](#output\_filestore\_instance\_id) | The Google Filestore instance id. |
| <a name="output_filestore_location"></a> [filestore\_location](#output\_filestore\_location) | The Google Filestore location. |
| <a name="output_firewall_policy_name"></a> [firewall\_policy\_name](#output\_firewall\_policy\_name) | The Google VPC firewall policy name. |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | The Google Project name. |
| <a name="output_registration_command"></a> [registration\_command](#output\_registration\_command) | The Anyscale registration command. |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | The Google VPC public subnet name. |
| <a name="output_subnet_region"></a> [subnet\_region](#output\_subnet\_region) | The Google VPC public subnet region. |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | The Google VPC network name. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
