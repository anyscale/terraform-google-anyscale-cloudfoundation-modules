# google-anyscale-iam examples

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
| <a name="module_all_defaults"></a> [all\_defaults](#module\_all\_defaults) | ../ | n/a |
| <a name="module_iam_cluster_node_only_role"></a> [iam\_cluster\_node\_only\_role](#module\_iam\_cluster\_node\_only\_role) | ../ | n/a |
| <a name="module_kitchen_sink"></a> [kitchen\_sink](#module\_kitchen\_sink) | ../ | n/a |
| <a name="module_test_no_resources"></a> [test\_no\_resources](#module\_test\_no\_resources) | ../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_deploy_env"></a> [anyscale\_deploy\_env](#input\_anyscale\_deploy\_env) | (Required) Anyscale deploy environment. Used in resource names and tags. | `string` | n/a | yes |
| <a name="input_google_project_id"></a> [google\_project\_id](#input\_google\_project\_id) | ID of the Project to put these resources in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_defaults_access_role_email"></a> [all\_defaults\_access\_role\_email](#output\_all\_defaults\_access\_role\_email) | All Defaults - Anyscale cross account access role email |
| <a name="output_all_defaults_access_role_id"></a> [all\_defaults\_access\_role\_id](#output\_all\_defaults\_access\_role\_id) | All Defaults - Anyscale cross account access role ID |
| <a name="output_all_defaults_access_role_name"></a> [all\_defaults\_access\_role\_name](#output\_all\_defaults\_access\_role\_name) | All Defaults - Anyscale cross account access role name |
| <a name="output_all_defaults_access_role_unique_id"></a> [all\_defaults\_access\_role\_unique\_id](#output\_all\_defaults\_access\_role\_unique\_id) | All Defaults - Anyscale cross account access role unique ID |
| <a name="output_all_defaults_cluster_node_role_email"></a> [all\_defaults\_cluster\_node\_role\_email](#output\_all\_defaults\_cluster\_node\_role\_email) | All Defaults - Anyscale cluster node role email |
| <a name="output_all_defaults_cluster_node_role_id"></a> [all\_defaults\_cluster\_node\_role\_id](#output\_all\_defaults\_cluster\_node\_role\_id) | All Defaults - Anyscale cluster node role ID |
| <a name="output_all_defaults_cluster_node_role_name"></a> [all\_defaults\_cluster\_node\_role\_name](#output\_all\_defaults\_cluster\_node\_role\_name) | All Defaults - Anyscale cluster node role name |
| <a name="output_all_defaults_cluster_node_role_unique_id"></a> [all\_defaults\_cluster\_node\_role\_unique\_id](#output\_all\_defaults\_cluster\_node\_role\_unique\_id) | All Defaults - Anyscale cluster node role unique ID |
| <a name="output_iam_cluster_node_only_role_access_role_email"></a> [iam\_cluster\_node\_only\_role\_access\_role\_email](#output\_iam\_cluster\_node\_only\_role\_access\_role\_email) | Cluster Node Only - Anyscale cross account access role email |
| <a name="output_iam_cluster_node_only_role_access_role_id"></a> [iam\_cluster\_node\_only\_role\_access\_role\_id](#output\_iam\_cluster\_node\_only\_role\_access\_role\_id) | Cluster Node Only - Anyscale cross account access role ID |
| <a name="output_iam_cluster_node_only_role_access_role_name"></a> [iam\_cluster\_node\_only\_role\_access\_role\_name](#output\_iam\_cluster\_node\_only\_role\_access\_role\_name) | Cluster Node Only - Anyscale cross account access role name |
| <a name="output_iam_cluster_node_only_role_access_role_unique_id"></a> [iam\_cluster\_node\_only\_role\_access\_role\_unique\_id](#output\_iam\_cluster\_node\_only\_role\_access\_role\_unique\_id) | Cluster Node Only - Anyscale cross account access role unique ID |
| <a name="output_iam_cluster_node_only_role_cluster_node_role_email"></a> [iam\_cluster\_node\_only\_role\_cluster\_node\_role\_email](#output\_iam\_cluster\_node\_only\_role\_cluster\_node\_role\_email) | Cluster Node Only - Anyscale cluster node role email |
| <a name="output_iam_cluster_node_only_role_cluster_node_role_id"></a> [iam\_cluster\_node\_only\_role\_cluster\_node\_role\_id](#output\_iam\_cluster\_node\_only\_role\_cluster\_node\_role\_id) | Cluster Node Only - Anyscale cluster node role ID |
| <a name="output_iam_cluster_node_only_role_cluster_node_role_name"></a> [iam\_cluster\_node\_only\_role\_cluster\_node\_role\_name](#output\_iam\_cluster\_node\_only\_role\_cluster\_node\_role\_name) | Cluster Node Only - Anyscale cluster node role name |
| <a name="output_iam_cluster_node_only_role_cluster_node_role_unique_id"></a> [iam\_cluster\_node\_only\_role\_cluster\_node\_role\_unique\_id](#output\_iam\_cluster\_node\_only\_role\_cluster\_node\_role\_unique\_id) | Cluster Node Only - Anyscale cluster node role unique ID |
| <a name="output_kitchen_sink_access_role_email"></a> [kitchen\_sink\_access\_role\_email](#output\_kitchen\_sink\_access\_role\_email) | Kitchen Sink - Anyscale cross account access role email |
| <a name="output_kitchen_sink_access_role_id"></a> [kitchen\_sink\_access\_role\_id](#output\_kitchen\_sink\_access\_role\_id) | Kitchen Sink - Anyscale cross account access role ID |
| <a name="output_kitchen_sink_access_role_name"></a> [kitchen\_sink\_access\_role\_name](#output\_kitchen\_sink\_access\_role\_name) | Kitchen Sink - Anyscale cross account access role name |
| <a name="output_kitchen_sink_access_role_unique_id"></a> [kitchen\_sink\_access\_role\_unique\_id](#output\_kitchen\_sink\_access\_role\_unique\_id) | Kitchen Sink - Anyscale cross account access role unique ID |
| <a name="output_kitchen_sink_cluster_node_role_email"></a> [kitchen\_sink\_cluster\_node\_role\_email](#output\_kitchen\_sink\_cluster\_node\_role\_email) | Kitchen Sink - Anyscale cluster node role email |
| <a name="output_kitchen_sink_cluster_node_role_id"></a> [kitchen\_sink\_cluster\_node\_role\_id](#output\_kitchen\_sink\_cluster\_node\_role\_id) | Kitchen Sink - Anyscale cluster node role ID |
| <a name="output_kitchen_sink_cluster_node_role_name"></a> [kitchen\_sink\_cluster\_node\_role\_name](#output\_kitchen\_sink\_cluster\_node\_role\_name) | Kitchen Sink - Anyscale cluster node role name |
| <a name="output_kitchen_sink_cluster_node_role_unique_id"></a> [kitchen\_sink\_cluster\_node\_role\_unique\_id](#output\_kitchen\_sink\_cluster\_node\_role\_unique\_id) | Kitchen Sink - Anyscale cluster node role unique ID |
| <a name="output_test_no_resources"></a> [test\_no\_resources](#output\_test\_no\_resources) | The outputs of the no\_resource resource - should be empty |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
