[![Build Status][badge-build]][build-status]
[![Terraform Version][badge-terraform]](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version][badge-tf-google]](https://github.com/terraform-providers/terraform-provider-google/releases)
# google-anyscale-iam

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.78.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_iam_workload_identity_pool.anyscale_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool) | resource |
| [google_iam_workload_identity_pool_provider.anyscale_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider) | resource |
| [google_project_iam_binding.anyscale_cluster_node_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_member.anyscale_access_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.anyscale_access_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.anyscale_cluster_node_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_binding.anyscale_access_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [google_service_account_iam_binding.anyscale_workload_identity_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [random_id.random_char_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_access_aws_account_id"></a> [anyscale\_access\_aws\_account\_id](#input\_anyscale\_access\_aws\_account\_id) | (Optional) The AWS account ID to grant access to. This will be overridden by `workload_anyscale_aws_account_id`. Default is `525325868955`. | `string` | `"525325868955"` | no |
| <a name="input_anyscale_access_role_binding_permissions"></a> [anyscale\_access\_role\_binding\_permissions](#input\_anyscale\_access\_role\_binding\_permissions) | (Optional) A list of permission roles to grant to the Anyscale IAM access role at the Service Account level.<br>Default is `["roles/iam.serviceAccountTokenCreator"]`. | `list(string)` | <pre>[<br>  "roles/iam.serviceAccountTokenCreator"<br>]</pre> | no |
| <a name="input_anyscale_access_role_description"></a> [anyscale\_access\_role\_description](#input\_anyscale\_access\_role\_description) | (Optional) Anyscale IAM access role description. If this is `null` the description will be set to "Anyscale access role". Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_access_role_name"></a> [anyscale\_access\_role\_name](#input\_anyscale\_access\_role\_name) | (Optional, forces creation of new resource) The name of the Anyscale IAM access role. Conflicts with anyscale\_access\_role\_name\_prefix. Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_access_role_name_prefix"></a> [anyscale\_access\_role\_name\_prefix](#input\_anyscale\_access\_role\_name\_prefix) | (Optional, forces creation of new resource) The prefix of the Anyscale IAM access role. Conflicts with anyscale\_access\_role\_name. Default is `anyscale-iam-role-`. | `string` | `"anyscale-crossacct-role-"` | no |
| <a name="input_anyscale_access_role_project_permissions"></a> [anyscale\_access\_role\_project\_permissions](#input\_anyscale\_access\_role\_project\_permissions) | (Optional) A list of permission roles to grant to the Anyscale IAM access role at the project level.<br>Default is `["roles/owner"]`. | `list(string)` | <pre>[<br>  "roles/owner"<br>]</pre> | no |
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID | `string` | `null` | no |
| <a name="input_anyscale_cluster_node_role_description"></a> [anyscale\_cluster\_node\_role\_description](#input\_anyscale\_cluster\_node\_role\_description) | (Optional) IAM cluster node role description. If this is `null` the description will be set to "Anyscale cluster node role". Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_cluster_node_role_name"></a> [anyscale\_cluster\_node\_role\_name](#input\_anyscale\_cluster\_node\_role\_name) | (Optional, forces creation of new resource) The name of the Anyscale IAM cluster node role. Conflicts with anyscale\_cluster\_node\_role\_name\_prefix. Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_cluster_node_role_name_prefix"></a> [anyscale\_cluster\_node\_role\_name\_prefix](#input\_anyscale\_cluster\_node\_role\_name\_prefix) | (Optional, forces creation of new resource) The prefix of the Anyscale IAM access role. Conflicts with anyscale\_cluster\_role\_node\_name. Default is `anyscale-cluster-`. | `string` | `"anyscale-cluster-"` | no |
| <a name="input_anyscale_cluster_node_role_permissions"></a> [anyscale\_cluster\_node\_role\_permissions](#input\_anyscale\_cluster\_node\_role\_permissions) | (Optional) A list of permission roles to grant to the Anyscale IAM cluster node role.<br>Default is `["roles/artifactregistry.reader"]`. | `list(string)` | <pre>[<br>  "roles/artifactregistry.reader"<br>]</pre> | no |
| <a name="input_anyscale_org_id"></a> [anyscale\_org\_id](#input\_anyscale\_org\_id) | (Required) Anyscale Organization ID | `string` | n/a | yes |
| <a name="input_anyscale_project_id"></a> [anyscale\_project\_id](#input\_anyscale\_project\_id) | (Optional) The ID of the project to create the resource in. If not provided, the provider project is used. Default is `null`. | `string` | `null` | no |
| <a name="input_create_anyscale_access_role"></a> [create\_anyscale\_access\_role](#input\_create\_anyscale\_access\_role) | (Optional) Determines whether to create the Anyscale access role. Default is `true`. | `bool` | `true` | no |
| <a name="input_create_anyscale_cluster_node_role"></a> [create\_anyscale\_cluster\_node\_role](#input\_create\_anyscale\_cluster\_node\_role) | (Optional) Determines whether to create the Anyscale cluster role. Default is `true`. | `bool` | `true` | no |
| <a name="input_enable_random_name_suffix"></a> [enable\_random\_name\_suffix](#input\_enable\_random\_name\_suffix) | (Optional) Determines if a suffix of random characters will be added to the Anyscale resources.<br>Default is `true` | `bool` | `true` | no |
| <a name="input_google_region"></a> [google\_region](#input\_google\_region) | (Optional) The Google region in which all resources will be created. If it is not provided, the provider region is used. Default is `null`. | `string` | `null` | no |
| <a name="input_module_enabled"></a> [module\_enabled](#input\_module\_enabled) | (Optional) Determines whether to create the resources inside this module. Default is `true`. | `bool` | `true` | no |
| <a name="input_random_char_length"></a> [random\_char\_length](#input\_random\_char\_length) | (Optional) Sets the length of random characters to be appended as a suffix.<br>Depends on `random_bucket_suffix` being set to `true`.<br>Must be an even number, and must be at least 4.<br>Default is `4`. | `number` | `4` | no |
| <a name="input_workload_anyscale_aws_account_id"></a> [workload\_anyscale\_aws\_account\_id](#input\_workload\_anyscale\_aws\_account\_id) | (Optional) The AWS account ID to grant access to. This will override the `anyscale_access_aws_account_id` which is the default account ID to use. Default is `null`. | `string` | `null` | no |
| <a name="input_workload_identity_pool_description"></a> [workload\_identity\_pool\_description](#input\_workload\_identity\_pool\_description) | (Optional) The description of the workload identity pool. Default is `Used to provide Anyscale access from AWS.`. | `string` | `"Used to provide Anyscale access from AWS."` | no |
| <a name="input_workload_identity_pool_display_name"></a> [workload\_identity\_pool\_display\_name](#input\_workload\_identity\_pool\_display\_name) | (Optional) The display name of the workload identity pool. Must be less than or equal to 32 chars. Default is `Anyscale Cross Account AWS Access`. | `string` | `"Anyscale Cross Account Access"` | no |
| <a name="input_workload_identity_pool_name"></a> [workload\_identity\_pool\_name](#input\_workload\_identity\_pool\_name) | (Optional) The name of the workload identity pool. If it is not provided, the Anyscale Access role name is used. Default is `null`. | `string` | `null` | no |
| <a name="input_workload_identity_pool_provider_name"></a> [workload\_identity\_pool\_provider\_name](#input\_workload\_identity\_pool\_provider\_name) | (Optional) The name of the workload identity pool provider. If it is not provided, the Anyscale Access role name is used. Default is `null`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_anyscale_access_role_email"></a> [iam\_anyscale\_access\_role\_email](#output\_iam\_anyscale\_access\_role\_email) | Anyscale cross account access role email |
| <a name="output_iam_anyscale_access_role_id"></a> [iam\_anyscale\_access\_role\_id](#output\_iam\_anyscale\_access\_role\_id) | Anyscale cross account access role ID |
| <a name="output_iam_anyscale_access_role_name"></a> [iam\_anyscale\_access\_role\_name](#output\_iam\_anyscale\_access\_role\_name) | Anyscale cross account access role name |
| <a name="output_iam_anyscale_access_role_unique_id"></a> [iam\_anyscale\_access\_role\_unique\_id](#output\_iam\_anyscale\_access\_role\_unique\_id) | Anyscale cross account access role unique ID |
| <a name="output_iam_anyscale_cluster_node_role_email"></a> [iam\_anyscale\_cluster\_node\_role\_email](#output\_iam\_anyscale\_cluster\_node\_role\_email) | Anyscale cross account cluster node role email |
| <a name="output_iam_anyscale_cluster_node_role_id"></a> [iam\_anyscale\_cluster\_node\_role\_id](#output\_iam\_anyscale\_cluster\_node\_role\_id) | Anyscale cross account cluster node role ID |
| <a name="output_iam_anyscale_cluster_node_role_name"></a> [iam\_anyscale\_cluster\_node\_role\_name](#output\_iam\_anyscale\_cluster\_node\_role\_name) | Anyscale cross account cluster node role name |
| <a name="output_iam_anyscale_cluster_node_role_unique_id"></a> [iam\_anyscale\_cluster\_node\_role\_unique\_id](#output\_iam\_anyscale\_cluster\_node\_role\_unique\_id) | Anyscale cross account cluster node role unique ID |
| <a name="output_iam_workload_identity_pool_id"></a> [iam\_workload\_identity\_pool\_id](#output\_iam\_workload\_identity\_pool\_id) | Anyscale cross account workload identity pool ID |
| <a name="output_iam_workload_identity_pool_name"></a> [iam\_workload\_identity\_pool\_name](#output\_iam\_workload\_identity\_pool\_name) | Anyscale cross account workload identity pool name |
| <a name="output_iam_workload_identity_provider_id"></a> [iam\_workload\_identity\_provider\_id](#output\_iam\_workload\_identity\_provider\_id) | Anyscale cross account workload identity provider ID |
| <a name="output_iam_workload_identity_provider_name"></a> [iam\_workload\_identity\_provider\_name](#output\_iam\_workload\_identity\_provider\_name) | Anyscale cross account workload identity provider name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- References -->
[Terraform]: https://www.terraform.io
[Issues]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-tf-aws]: https://img.shields.io/badge/AWS-4.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/actions
