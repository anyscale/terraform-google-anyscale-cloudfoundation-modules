[![Build Status][badge-build]][build-status]
[![Terraform Version][badge-terraform]](https://github.com/hashicorp/terraform/releases)
[![OpenTofu Version][badge-opentofu]](https://github.com/opentofu/opentofu/releases)
[![Google Provider Version][badge-tf-google]](https://github.com/terraform-providers/terraform-provider-google/releases)
# google-anyscale-iam

This sub-module creates IAM related resources required for the Anyscale Platform. It should be used from the [root module](../../README.md).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.44.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_iam_workload_identity_pool.anyscale_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool) | resource |
| [google_iam_workload_identity_pool_provider.anyscale_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider) | resource |
| [google_project_iam_custom_role.anyscale_access_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_project_iam_member.anyscale_access_service_acct](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.anyscale_cluster_node_service_acct](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.gke_cluster_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.anyscale_access_service_acct](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.anyscale_cluster_node_service_acct](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.gke_cluster_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.anyscale_access_service_acct](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_service_account_iam_member.anyscale_cluster_node_service_acct](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_service_account_iam_member.anyscale_workload_identity_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [random_id.random_char_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_access_aws_account_id"></a> [anyscale\_access\_aws\_account\_id](#input\_anyscale\_access\_aws\_account\_id) | (Optional) The AWS account ID to grant access to. This will be overridden by `workload_anyscale_aws_account_id`. Default is `525325868955`. | `string` | `"525325868955"` | no |
| <a name="input_anyscale_access_role_description"></a> [anyscale\_access\_role\_description](#input\_anyscale\_access\_role\_description) | (Optional) Anyscale IAM access role description.<br/><br/>ex:<pre>anyscale_access_role_description = "Anyscale access role"</pre> | `string` | `"Anyscale access role"` | no |
| <a name="input_anyscale_access_role_id"></a> [anyscale\_access\_role\_id](#input\_anyscale\_access\_role\_id) | (Optional, forces creation of new resource) The ID of the Anyscale IAM access role.<br/><br/>Overrides `anyscale_access_role_id_prefix`.<br/><br/>ex:<pre>anyscale_access_role_id = "anyscale_access_role"</pre> | `string` | `null` | no |
| <a name="input_anyscale_access_role_id_prefix"></a> [anyscale\_access\_role\_id\_prefix](#input\_anyscale\_access\_role\_id\_prefix) | (Optional, forces creation of new resource) The prefix of the Anyscale IAM access role.<br/><br/>If `anyscale_access_role_id` is provided, it will override this variable.<br/>If set to `null`, the prefix will be set to \"anyscale\_\" in a local variable.<br/><br/>ex:<pre>anyscale_access_role_id_prefix = "anyscale_crossacct_role_"</pre> | `string` | `"anyscale_crossacct_role_"` | no |
| <a name="input_anyscale_access_service_acct_binding_permissions"></a> [anyscale\_access\_service\_acct\_binding\_permissions](#input\_anyscale\_access\_service\_acct\_binding\_permissions) | (Optional) A list of permission roles to grant to the Anyscale IAM access service account at the Service Account level.<br/>Default is `["roles/iam.serviceAccountTokenCreator"]`. | `list(string)` | <pre>[<br/>  "roles/iam.serviceAccountTokenCreator"<br/>]</pre> | no |
| <a name="input_anyscale_access_service_acct_description"></a> [anyscale\_access\_service\_acct\_description](#input\_anyscale\_access\_service\_acct\_description) | (Optional) Anyscale IAM access service account description.<br/><br/>If this is `null` the description will be set to \"Anyscale access service account\" in a local variable.<br/><br/>ex:<pre>anyscale_access_service_acct_description = "Anyscale access service account"</pre> | `string` | `null` | no |
| <a name="input_anyscale_access_service_acct_name"></a> [anyscale\_access\_service\_acct\_name](#input\_anyscale\_access\_service\_acct\_name) | (Optional, forces creation of new resource)<br/>The name of the Anyscale IAM access service account.<br/><br/>Overrides `anyscale_access_service_acct_name_prefix`.<br/><br/>ex:<pre>anyscale_access_service_acct_name = "anyscale-access-service-acct"</pre> | `string` | `null` | no |
| <a name="input_anyscale_access_service_acct_name_prefix"></a> [anyscale\_access\_service\_acct\_name\_prefix](#input\_anyscale\_access\_service\_acct\_name\_prefix) | (Optional, forces creation of new resource)<br/>The prefix of the Anyscale IAM access service account.<br/><br/>Conflicts with anyscale\_access\_service\_acct\_name.<br/><br/>ex:<pre>anyscale_access_service_acct_name_prefix = "anyscale-access-"</pre> | `string` | `"anyscale-crossacct-"` | no |
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID | `string` | `null` | no |
| <a name="input_anyscale_cluster_node_service_acct_description"></a> [anyscale\_cluster\_node\_service\_acct\_description](#input\_anyscale\_cluster\_node\_service\_acct\_description) | (Optional) IAM cluster node service account description.<br/><br/>If this is `null` the description will be set to `Anyscale cluster node service account` in a local variable.<br/><br/>ex:<pre>anyscale_cluster_node_service_acct_description = "Anyscale cluster node service account for cloud"</pre> | `string` | `null` | no |
| <a name="input_anyscale_cluster_node_service_acct_name"></a> [anyscale\_cluster\_node\_service\_acct\_name](#input\_anyscale\_cluster\_node\_service\_acct\_name) | (Optional, forces creation of new resource) The name of the Anyscale IAM cluster node service account.<br/><br/>Overrides `anyscale_cluster_node_service_acct_name_prefix`.<br/><br/>ex:<pre>anyscale_cluster_node_service_acct_name = "anyscale-cluster-acct"</pre> | `string` | `null` | no |
| <a name="input_anyscale_cluster_node_service_acct_name_prefix"></a> [anyscale\_cluster\_node\_service\_acct\_name\_prefix](#input\_anyscale\_cluster\_node\_service\_acct\_name\_prefix) | (Optional, forces creation of new resource) The prefix of the Anyscale IAM cluster service account.<br/><br/>If `anyscale_cluster_node_service_acct_name` is provided, it will override this variable.<br/><br/>ex:<pre>anyscale_cluster_node_service_acct_name_prefix = "anyscale-cluster-"</pre> | `string` | `"anyscale-cluster-"` | no |
| <a name="input_anyscale_cluster_node_service_acct_permissions"></a> [anyscale\_cluster\_node\_service\_acct\_permissions](#input\_anyscale\_cluster\_node\_service\_acct\_permissions) | (Optional) A list of permission roles to grant to the Anyscale IAM cluster node service account.<br/><br/>ex:<pre>anyscale_cluster_node_service_acct_permissions = ["roles/artifactregistry.reader"]</pre> | `list(string)` | <pre>[<br/>  "roles/artifactregistry.reader"<br/>]</pre> | no |
| <a name="input_anyscale_org_id"></a> [anyscale\_org\_id](#input\_anyscale\_org\_id) | (Required) Anyscale Organization ID | `string` | n/a | yes |
| <a name="input_anyscale_project_id"></a> [anyscale\_project\_id](#input\_anyscale\_project\_id) | (Optional) The ID of the project to create the resource in. If not provided, the provider project is used. Default is `null`. | `string` | `null` | no |
| <a name="input_create_anyscale_access_role"></a> [create\_anyscale\_access\_role](#input\_create\_anyscale\_access\_role) | (Optional) Determines whether to create the Anyscale access role.<br/><br/>ex:<pre>create_anyscale_access_role = true</pre> | `bool` | `true` | no |
| <a name="input_create_anyscale_access_service_acct"></a> [create\_anyscale\_access\_service\_acct](#input\_create\_anyscale\_access\_service\_acct) | (Optional) Determines whether to create the Anyscale access service account. Default is `true`. | `bool` | `true` | no |
| <a name="input_create_anyscale_cluster_node_service_acct"></a> [create\_anyscale\_cluster\_node\_service\_acct](#input\_create\_anyscale\_cluster\_node\_service\_acct) | (Optional) Determines whether to create the Anyscale cluster service account.<br/><br/>ex:<pre>create_anyscale_cluster_node_service_acct = true</pre> | `bool` | `true` | no |
| <a name="input_create_gke_cluster_service_acct"></a> [create\_gke\_cluster\_service\_acct](#input\_create\_gke\_cluster\_service\_acct) | (Optional) Determines whether to create the GKE Cluster service account.<br/><br/>ex:<pre>create_gke_cluster_service_acct = true</pre> | `bool` | `false` | no |
| <a name="input_enable_anyscale_cluster_logging_monitoring"></a> [enable\_anyscale\_cluster\_logging\_monitoring](#input\_enable\_anyscale\_cluster\_logging\_monitoring) | (Optional) Determines whether to grant the Cluster Node access to the monitoring and logging.<br/><br/>ex:<pre>enable_anyscale_cluster_logging_monitoring = true</pre> | `bool` | `false` | no |
| <a name="input_enable_gke_cluster_logging_monitoring"></a> [enable\_gke\_cluster\_logging\_monitoring](#input\_enable\_gke\_cluster\_logging\_monitoring) | (Optional) Determines whether to grant the GKE Cluster service account access to the monitoring and logging.<br/><br/>ex:<pre>enable_gke_cluster_logging_monitoring = true</pre> | `bool` | `false` | no |
| <a name="input_enable_random_name_suffix"></a> [enable\_random\_name\_suffix](#input\_enable\_random\_name\_suffix) | (Optional) Determines if a suffix of random characters will be added to the Anyscale resources.<br/>Default is `true` | `bool` | `true` | no |
| <a name="input_existing_anyscale_access_role_name"></a> [existing\_anyscale\_access\_role\_name](#input\_existing\_anyscale\_access\_role\_name) | (Optional) The name of an existing Anyscale IAM access role to use.<br/><br/>If provided, will skip creating the Anyscale access role.<br/><br/>ex:<pre>existing_anyscale_access_role_name = "projects/1234567890/roles/anyscale_access_role"</pre> | `string` | `null` | no |
| <a name="input_existing_workload_identity_provider_name"></a> [existing\_workload\_identity\_provider\_name](#input\_existing\_workload\_identity\_provider\_name) | (Optional) The name of an existing workload identity provider to use.<br/><br/>If provided, will skip creating the workload identity pool and provider.<br/><br/>You can retrieve the name of an existing Workload Identity Provider by running the following command:<pre>gcloud iam workload-identity-pools providers list --location global --workload-identity-pool anyscale-access-pool</pre>ex:<pre>existing_workload_identity_provider_name = "projects/1234567890/locations/global/workloadIdentityPools/anyscale-access-pool/providers/anyscale-access-provider"</pre><pre></pre> | `string` | `null` | no |
| <a name="input_gke_cluster_service_acct_description"></a> [gke\_cluster\_service\_acct\_description](#input\_gke\_cluster\_service\_acct\_description) | (Optional) GKE Cluster service account description.<br/><br/>If this is `null` the description will be set to `Anyscale GKE cluster Service Account` in a local variable.<br/><br/>ex:<pre>gke_cluster_sa_description = "Anyscale GKE cluster Service Account"</pre> | `string` | `null` | no |
| <a name="input_gke_cluster_service_acct_name"></a> [gke\_cluster\_service\_acct\_name](#input\_gke\_cluster\_service\_acct\_name) | (Optional, forces creation of new resource) The name of the GKE Cluster service account.<br/><br/>Overrides `gke_cluster_service_acct_name_prefix`.<br/><br/>ex:<pre>gke_cluster_service_acct_name = "gke-cluster-service-acct"</pre> | `string` | `null` | no |
| <a name="input_gke_cluster_service_acct_name_prefix"></a> [gke\_cluster\_service\_acct\_name\_prefix](#input\_gke\_cluster\_service\_acct\_name\_prefix) | (Optional, forces creation of new resource) The prefix of the GKE Cluster service account.<br/><br/>If `gke_cluster_service_acct_name` is provided, it will override this variable.<br/><br/>ex:<pre>gke_cluster_service_acct_name_prefix = "gke-cluster-"</pre> | `string` | `"gke-cluster-"` | no |
| <a name="input_gke_cluster_service_acct_permissions"></a> [gke\_cluster\_service\_acct\_permissions](#input\_gke\_cluster\_service\_acct\_permissions) | (Optional) A list of permission roles to grant to the GKE Cluster service account.<br/><br/>ex:<pre>gke_cluster_service_acct_permissions = ["roles/container.defaultNodeServiceAccount"]</pre> | `list(string)` | <pre>[<br/>  "roles/container.defaultNodeServiceAccount",<br/>  "roles/monitoring.metricWriter",<br/>  "roles/stackdriver.resourceMetadata.writer",<br/>  "roles/artifactregistry.reader"<br/>]</pre> | no |
| <a name="input_google_region"></a> [google\_region](#input\_google\_region) | (Optional) The Google region in which all resources will be created. If it is not provided, the provider region is used. Default is `null`. | `string` | `null` | no |
| <a name="input_module_enabled"></a> [module\_enabled](#input\_module\_enabled) | (Optional) Determines whether to create the resources inside this module. Default is `true`. | `bool` | `true` | no |
| <a name="input_random_char_length"></a> [random\_char\_length](#input\_random\_char\_length) | (Optional) Sets the length of random characters to be appended as a suffix.<br/>Depends on `random_bucket_suffix` being set to `true`.<br/>Must be an even number, and must be at least 4.<br/>Default is `4`. | `number` | `4` | no |
| <a name="input_workload_anyscale_aws_account_id"></a> [workload\_anyscale\_aws\_account\_id](#input\_workload\_anyscale\_aws\_account\_id) | (Optional) The AWS account ID to grant access to. This will override the `anyscale_access_aws_account_id` which is the default account ID to use. Default is `null`. | `string` | `null` | no |
| <a name="input_workload_identity_pool_description"></a> [workload\_identity\_pool\_description](#input\_workload\_identity\_pool\_description) | (Optional) The description of the workload identity pool. Default is `Used to provide Anyscale access from AWS.`. | `string` | `"Used to provide Anyscale access from AWS."` | no |
| <a name="input_workload_identity_pool_display_name"></a> [workload\_identity\_pool\_display\_name](#input\_workload\_identity\_pool\_display\_name) | (Optional) The display name of the workload identity pool. Must be less than or equal to 32 chars. Default is `Anyscale Cross Account AWS Access`. | `string` | `"Anyscale Cross Account Access"` | no |
| <a name="input_workload_identity_pool_name"></a> [workload\_identity\_pool\_name](#input\_workload\_identity\_pool\_name) | (Optional) The name of the workload identity pool. If it is not provided, the Anyscale Access service account name is used. Default is `null`. | `string` | `null` | no |
| <a name="input_workload_identity_pool_provider_name"></a> [workload\_identity\_pool\_provider\_name](#input\_workload\_identity\_pool\_provider\_name) | (Optional) The name of the workload identity pool provider. If it is not provided, the Anyscale Access service account name is used. Default is `null`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_anyscale_access_service_acct_email"></a> [iam\_anyscale\_access\_service\_acct\_email](#output\_iam\_anyscale\_access\_service\_acct\_email) | Anyscale cross account access service account email |
| <a name="output_iam_anyscale_access_service_acct_id"></a> [iam\_anyscale\_access\_service\_acct\_id](#output\_iam\_anyscale\_access\_service\_acct\_id) | Anyscale cross account access service account ID |
| <a name="output_iam_anyscale_access_service_acct_name"></a> [iam\_anyscale\_access\_service\_acct\_name](#output\_iam\_anyscale\_access\_service\_acct\_name) | Anyscale cross account access service account name |
| <a name="output_iam_anyscale_access_service_acct_unique_id"></a> [iam\_anyscale\_access\_service\_acct\_unique\_id](#output\_iam\_anyscale\_access\_service\_acct\_unique\_id) | Anyscale cross account access service account unique ID |
| <a name="output_iam_anyscale_cluster_node_service_acct_email"></a> [iam\_anyscale\_cluster\_node\_service\_acct\_email](#output\_iam\_anyscale\_cluster\_node\_service\_acct\_email) | Anyscale cross account cluster node service account email |
| <a name="output_iam_anyscale_cluster_node_service_acct_id"></a> [iam\_anyscale\_cluster\_node\_service\_acct\_id](#output\_iam\_anyscale\_cluster\_node\_service\_acct\_id) | Anyscale cross account cluster node service account ID |
| <a name="output_iam_anyscale_cluster_node_service_acct_name"></a> [iam\_anyscale\_cluster\_node\_service\_acct\_name](#output\_iam\_anyscale\_cluster\_node\_service\_acct\_name) | Anyscale cross account cluster node service account name |
| <a name="output_iam_anyscale_cluster_node_service_acct_unique_id"></a> [iam\_anyscale\_cluster\_node\_service\_acct\_unique\_id](#output\_iam\_anyscale\_cluster\_node\_service\_acct\_unique\_id) | Anyscale cross account cluster node service account unique ID |
| <a name="output_iam_gke_cluster_service_acct_email"></a> [iam\_gke\_cluster\_service\_acct\_email](#output\_iam\_gke\_cluster\_service\_acct\_email) | Anyscale cross account GKE cluster service account email |
| <a name="output_iam_gke_cluster_service_acct_id"></a> [iam\_gke\_cluster\_service\_acct\_id](#output\_iam\_gke\_cluster\_service\_acct\_id) | Anyscale cross account GKE cluster service account ID |
| <a name="output_iam_gke_cluster_service_acct_name"></a> [iam\_gke\_cluster\_service\_acct\_name](#output\_iam\_gke\_cluster\_service\_acct\_name) | Anyscale cross account GKE cluster service account name |
| <a name="output_iam_gke_cluster_service_acct_unique_id"></a> [iam\_gke\_cluster\_service\_acct\_unique\_id](#output\_iam\_gke\_cluster\_service\_acct\_unique\_id) | Anyscale cross account GKE cluster service account unique ID |
| <a name="output_iam_workload_identity_pool_id"></a> [iam\_workload\_identity\_pool\_id](#output\_iam\_workload\_identity\_pool\_id) | Anyscale cross account workload identity pool ID |
| <a name="output_iam_workload_identity_pool_name"></a> [iam\_workload\_identity\_pool\_name](#output\_iam\_workload\_identity\_pool\_name) | Anyscale cross account workload identity pool name |
| <a name="output_iam_workload_identity_provider_id"></a> [iam\_workload\_identity\_provider\_id](#output\_iam\_workload\_identity\_provider\_id) | Anyscale cross account workload identity provider ID |
| <a name="output_iam_workload_identity_provider_name"></a> [iam\_workload\_identity\_provider\_name](#output\_iam\_workload\_identity\_provider\_name) | Anyscale cross account workload identity provider name |
<!-- END_TF_DOCS -->

<!-- References -->
[Terraform]: https://www.terraform.io
[OpenTofu]: https://opentofu.org/
[Issues]: https://github.com/anyscale/terraform-google-anyscale-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/terraform-google-anyscale-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-opentofu]: https://img.shields.io/badge/opentofu-1.x%20-623CE4.svg?logo=terraform
[badge-tf-google]: https://img.shields.io/badge/Google-6.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/terraform-google-anyscale-cloudfoundation-modules/actions
