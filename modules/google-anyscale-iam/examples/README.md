# google-anyscale-iam examples

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_all_defaults"></a> [all\_defaults](#module\_all\_defaults) | ../ | n/a |
| <a name="module_iam_cluster_node_only_role"></a> [iam\_cluster\_node\_only\_role](#module\_iam\_cluster\_node\_only\_role) | ../ | n/a |
| <a name="module_iam_gke_cluster_only_role"></a> [iam\_gke\_cluster\_only\_role](#module\_iam\_gke\_cluster\_only\_role) | ../ | n/a |
| <a name="module_kitchen_sink"></a> [kitchen\_sink](#module\_kitchen\_sink) | ../ | n/a |
| <a name="module_test_no_resources"></a> [test\_no\_resources](#module\_test\_no\_resources) | ../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_organization_id"></a> [anyscale\_organization\_id](#input\_anyscale\_organization\_id) | (Required) Anyscale Organization ID | `string` | n/a | yes |
| <a name="input_existing_workload_identity_provider_name"></a> [existing\_workload\_identity\_provider\_name](#input\_existing\_workload\_identity\_provider\_name) | (Optional) Existing Workload Identity Provider Name.<br><br>The name of an existing Workload Identity Provider that you'd like to use. This can be in a different project.<br>If provided, this will skip creating a new Workload Identity Provider with the Anyscale IAM module.<br><br>ex:<pre>existing_workload_identity_provider_name = "projects/1234567890/locations/global/workloadIdentityPools/anyscale-existing-pool/providers/anyscale-existing-provider"</pre> | `string` | `null` | no |
| <a name="input_google_project_id"></a> [google\_project\_id](#input\_google\_project\_id) | ID of the Project to put these resources in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_defaults_access_role_email"></a> [all\_defaults\_access\_role\_email](#output\_all\_defaults\_access\_role\_email) | All Defaults - Anyscale cross account access Service Account email |
| <a name="output_all_defaults_access_role_id"></a> [all\_defaults\_access\_role\_id](#output\_all\_defaults\_access\_role\_id) | All Defaults - Anyscale cross account access Service Account ID |
| <a name="output_all_defaults_access_role_name"></a> [all\_defaults\_access\_role\_name](#output\_all\_defaults\_access\_role\_name) | All Defaults - Anyscale cross account access Service Account name |
| <a name="output_all_defaults_access_role_unique_id"></a> [all\_defaults\_access\_role\_unique\_id](#output\_all\_defaults\_access\_role\_unique\_id) | All Defaults - Anyscale cross account access Service Account unique ID |
| <a name="output_all_defaults_cluster_node_service_acct_email"></a> [all\_defaults\_cluster\_node\_service\_acct\_email](#output\_all\_defaults\_cluster\_node\_service\_acct\_email) | All Defaults - Anyscale cluster node Service Account email |
| <a name="output_all_defaults_cluster_node_service_acct_id"></a> [all\_defaults\_cluster\_node\_service\_acct\_id](#output\_all\_defaults\_cluster\_node\_service\_acct\_id) | All Defaults - Anyscale cluster node Service Account ID |
| <a name="output_all_defaults_cluster_node_service_acct_name"></a> [all\_defaults\_cluster\_node\_service\_acct\_name](#output\_all\_defaults\_cluster\_node\_service\_acct\_name) | All Defaults - Anyscale cluster node Service Account name |
| <a name="output_all_defaults_cluster_node_service_acct_unique_id"></a> [all\_defaults\_cluster\_node\_service\_acct\_unique\_id](#output\_all\_defaults\_cluster\_node\_service\_acct\_unique\_id) | All Defaults - Anyscale cluster node Service Account unique ID |
| <a name="output_iam_cluster_node_only_role_access_role_email"></a> [iam\_cluster\_node\_only\_role\_access\_role\_email](#output\_iam\_cluster\_node\_only\_role\_access\_role\_email) | Cluster Node Only - Anyscale cross account access Service Account email |
| <a name="output_iam_cluster_node_only_role_access_role_id"></a> [iam\_cluster\_node\_only\_role\_access\_role\_id](#output\_iam\_cluster\_node\_only\_role\_access\_role\_id) | Cluster Node Only - Anyscale cross account access Service Account ID |
| <a name="output_iam_cluster_node_only_role_access_role_name"></a> [iam\_cluster\_node\_only\_role\_access\_role\_name](#output\_iam\_cluster\_node\_only\_role\_access\_role\_name) | Cluster Node Only - Anyscale cross account access Service Account name |
| <a name="output_iam_cluster_node_only_role_access_role_unique_id"></a> [iam\_cluster\_node\_only\_role\_access\_role\_unique\_id](#output\_iam\_cluster\_node\_only\_role\_access\_role\_unique\_id) | Cluster Node Only - Anyscale cross account access Service Account unique ID |
| <a name="output_iam_cluster_node_only_role_cluster_node_service_acct_email"></a> [iam\_cluster\_node\_only\_role\_cluster\_node\_service\_acct\_email](#output\_iam\_cluster\_node\_only\_role\_cluster\_node\_service\_acct\_email) | Cluster Node Only - Anyscale cluster node Service Account email |
| <a name="output_iam_cluster_node_only_role_cluster_node_service_acct_id"></a> [iam\_cluster\_node\_only\_role\_cluster\_node\_service\_acct\_id](#output\_iam\_cluster\_node\_only\_role\_cluster\_node\_service\_acct\_id) | Cluster Node Only - Anyscale cluster node Service Account ID |
| <a name="output_iam_cluster_node_only_role_cluster_node_service_acct_name"></a> [iam\_cluster\_node\_only\_role\_cluster\_node\_service\_acct\_name](#output\_iam\_cluster\_node\_only\_role\_cluster\_node\_service\_acct\_name) | Cluster Node Only - Anyscale cluster node Service Account name |
| <a name="output_iam_cluster_node_only_role_cluster_node_service_acct_unique_id"></a> [iam\_cluster\_node\_only\_role\_cluster\_node\_service\_acct\_unique\_id](#output\_iam\_cluster\_node\_only\_role\_cluster\_node\_service\_acct\_unique\_id) | Cluster Node Only - Anyscale cluster node Service Account unique ID |
| <a name="output_kitchen_sink_access_role_email"></a> [kitchen\_sink\_access\_role\_email](#output\_kitchen\_sink\_access\_role\_email) | Kitchen Sink - Anyscale cross account access Service Account email |
| <a name="output_kitchen_sink_access_role_id"></a> [kitchen\_sink\_access\_role\_id](#output\_kitchen\_sink\_access\_role\_id) | Kitchen Sink - Anyscale cross account access Service Account ID |
| <a name="output_kitchen_sink_access_role_name"></a> [kitchen\_sink\_access\_role\_name](#output\_kitchen\_sink\_access\_role\_name) | Kitchen Sink - Anyscale cross account access Service Account name |
| <a name="output_kitchen_sink_access_role_unique_id"></a> [kitchen\_sink\_access\_role\_unique\_id](#output\_kitchen\_sink\_access\_role\_unique\_id) | Kitchen Sink - Anyscale cross account access Service Account unique ID |
| <a name="output_kitchen_sink_cluster_node_service_acct_email"></a> [kitchen\_sink\_cluster\_node\_service\_acct\_email](#output\_kitchen\_sink\_cluster\_node\_service\_acct\_email) | Kitchen Sink - Anyscale cluster node Service Account email |
| <a name="output_kitchen_sink_cluster_node_service_acct_id"></a> [kitchen\_sink\_cluster\_node\_service\_acct\_id](#output\_kitchen\_sink\_cluster\_node\_service\_acct\_id) | Kitchen Sink - Anyscale cluster node Service Account ID |
| <a name="output_kitchen_sink_cluster_node_service_acct_name"></a> [kitchen\_sink\_cluster\_node\_service\_acct\_name](#output\_kitchen\_sink\_cluster\_node\_service\_acct\_name) | Kitchen Sink - Anyscale cluster node Service Account name |
| <a name="output_kitchen_sink_cluster_node_service_acct_unique_id"></a> [kitchen\_sink\_cluster\_node\_service\_acct\_unique\_id](#output\_kitchen\_sink\_cluster\_node\_service\_acct\_unique\_id) | Kitchen Sink - Anyscale cluster node Service Account unique ID |
| <a name="output_test_no_resources"></a> [test\_no\_resources](#output\_test\_no\_resources) | The outputs of the no\_resource resource - should be empty |
<!-- END_TF_DOCS -->
