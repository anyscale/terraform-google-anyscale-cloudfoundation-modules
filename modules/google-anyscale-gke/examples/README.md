# google-anyscale-gke examples

## Notes
This resource takes approximately 15-30 minutes to create the GKE Clusters.

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
| <a name="module_anyscale_cloudapis"></a> [anyscale\_cloudapis](#module\_anyscale\_cloudapis) | ../../google-anyscale-cloudapis | n/a |
| <a name="module_autopilot_gke"></a> [autopilot\_gke](#module\_autopilot\_gke) | ../ | n/a |
| <a name="module_autopilot_gke_iam"></a> [autopilot\_gke\_iam](#module\_autopilot\_gke\_iam) | ../../google-anyscale-iam | n/a |
| <a name="module_autopilot_gke_vpc"></a> [autopilot\_gke\_vpc](#module\_autopilot\_gke\_vpc) | ../../google-anyscale-vpc | n/a |
| <a name="module_gke_standard_autoscaling"></a> [gke\_standard\_autoscaling](#module\_gke\_standard\_autoscaling) | ../ | n/a |
| <a name="module_gke_standard_autoscaling_iam"></a> [gke\_standard\_autoscaling\_iam](#module\_gke\_standard\_autoscaling\_iam) | ../../google-anyscale-iam | n/a |
| <a name="module_gke_standard_autoscaling_vpc"></a> [gke\_standard\_autoscaling\_vpc](#module\_gke\_standard\_autoscaling\_vpc) | ../../google-anyscale-vpc | n/a |
| <a name="module_standard_gke_no_autoscaling"></a> [standard\_gke\_no\_autoscaling](#module\_standard\_gke\_no\_autoscaling) | ../ | n/a |
| <a name="module_standard_gke_no_autoscaling_iam"></a> [standard\_gke\_no\_autoscaling\_iam](#module\_standard\_gke\_no\_autoscaling\_iam) | ../../google-anyscale-iam | n/a |
| <a name="module_standard_gke_no_autoscaling_vpc"></a> [standard\_gke\_no\_autoscaling\_vpc](#module\_standard\_gke\_no\_autoscaling\_vpc) | ../../google-anyscale-vpc | n/a |
| <a name="module_test_no_resources"></a> [test\_no\_resources](#module\_test\_no\_resources) | ../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID | `string` | `null` | no |
| <a name="input_anyscale_deploy_env"></a> [anyscale\_deploy\_env](#input\_anyscale\_deploy\_env) | (Optional) Anyscale deploy environment. Used in resource names and tags.<br/><br/>ex:<pre>anyscale_deploy_env = "production"</pre> | `string` | `"test"` | no |
| <a name="input_anyscale_organization_id"></a> [anyscale\_organization\_id](#input\_anyscale\_organization\_id) | (Required) Anyscale Organization ID | `string` | n/a | yes |
| <a name="input_google_project_id"></a> [google\_project\_id](#input\_google\_project\_id) | ID of the Project to put these resources in | `string` | n/a | yes |
| <a name="input_google_region"></a> [google\_region](#input\_google\_region) | The Google region in which all resources will be created. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) A map of labels to all resources that accept labels. | `map(string)` | <pre>{<br/>  "environment": "test",<br/>  "test": true<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_autopilot_gke"></a> [autopilot\_gke](#output\_autopilot\_gke) | The outputs from the standard\_gke\_no\_autoscaling example. |
| <a name="output_gke_standard_autoscaling_cluster_endpoint"></a> [gke\_standard\_autoscaling\_cluster\_endpoint](#output\_gke\_standard\_autoscaling\_cluster\_endpoint) | The endpoint of the anyscale resource. |
| <a name="output_gke_standard_autoscaling_cluster_id"></a> [gke\_standard\_autoscaling\_cluster\_id](#output\_gke\_standard\_autoscaling\_cluster\_id) | The ID of the all defaults anyscale resource. |
| <a name="output_gke_standard_autoscaling_cluster_name"></a> [gke\_standard\_autoscaling\_cluster\_name](#output\_gke\_standard\_autoscaling\_cluster\_name) | The name of the anyscale resource. |
| <a name="output_standard_gke_no_autoscaling_outputs"></a> [standard\_gke\_no\_autoscaling\_outputs](#output\_standard\_gke\_no\_autoscaling\_outputs) | The outputs from the standard\_gke\_no\_autoscaling example. |
| <a name="output_test_no_resources"></a> [test\_no\_resources](#output\_test\_no\_resources) | The outputs of the no\_resource resource - should all be empty |
<!-- END_TF_DOCS -->
