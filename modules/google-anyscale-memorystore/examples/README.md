# google-anyscale-memorystore examples

## Notes
This resource takes approximately 10 minutes to create the memorystore

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
| <a name="module_kitchen_sink"></a> [kitchen\_sink](#module\_kitchen\_sink) | ../ | n/a |
| <a name="module_memorystore_cloudapis"></a> [memorystore\_cloudapis](#module\_memorystore\_cloudapis) | ../../google-anyscale-cloudapis | n/a |
| <a name="module_memorystore_vpc"></a> [memorystore\_vpc](#module\_memorystore\_vpc) | ../../google-anyscale-vpc | n/a |
| <a name="module_test_no_resources"></a> [test\_no\_resources](#module\_test\_no\_resources) | ../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID | `string` | `null` | no |
| <a name="input_anyscale_deploy_env"></a> [anyscale\_deploy\_env](#input\_anyscale\_deploy\_env) | (Optional) Anyscale deploy environment. Used in resource names and tags. | `string` | `"production"` | no |
| <a name="input_google_project_id"></a> [google\_project\_id](#input\_google\_project\_id) | ID of the Project to put these resources in | `string` | n/a | yes |
| <a name="input_google_region"></a> [google\_region](#input\_google\_region) | The Google region in which all resources will be created. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) A map of labels to all resources that accept labels. | `map(string)` | <pre>{<br>  "environment": "test",<br>  "test": true<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_defaults_anyscale_memorystore_host"></a> [all\_defaults\_anyscale\_memorystore\_host](#output\_all\_defaults\_anyscale\_memorystore\_host) | All Defaults - Anyscale Memorystore Host Name |
| <a name="output_all_defaults_anyscale_memorystore_id"></a> [all\_defaults\_anyscale\_memorystore\_id](#output\_all\_defaults\_anyscale\_memorystore\_id) | All Defaults - Anyscale Memorystore ID |
| <a name="output_all_defaults_anyscale_memorystore_port"></a> [all\_defaults\_anyscale\_memorystore\_port](#output\_all\_defaults\_anyscale\_memorystore\_port) | All Defaults - Anyscale Memorystore Port |
| <a name="output_kitchen_sink_anyscale_memorystore_current_location_id"></a> [kitchen\_sink\_anyscale\_memorystore\_current\_location\_id](#output\_kitchen\_sink\_anyscale\_memorystore\_current\_location\_id) | Kitchen Sink - Anyscale Memorystore Current Location ID |
| <a name="output_kitchen_sink_anyscale_memorystore_host"></a> [kitchen\_sink\_anyscale\_memorystore\_host](#output\_kitchen\_sink\_anyscale\_memorystore\_host) | Kitchen Sink - Anyscale Memorystore Host Name |
| <a name="output_kitchen_sink_anyscale_memorystore_id"></a> [kitchen\_sink\_anyscale\_memorystore\_id](#output\_kitchen\_sink\_anyscale\_memorystore\_id) | Kitchen Sink - Anyscale Memorystore ID |
| <a name="output_kitchen_sink_anyscale_memorystore_maintenance_schedule"></a> [kitchen\_sink\_anyscale\_memorystore\_maintenance\_schedule](#output\_kitchen\_sink\_anyscale\_memorystore\_maintenance\_schedule) | Kitchen Sink - Anyscale Memorystore Maintenance Schedule |
| <a name="output_kitchen_sink_anyscale_memorystore_port"></a> [kitchen\_sink\_anyscale\_memorystore\_port](#output\_kitchen\_sink\_anyscale\_memorystore\_port) | Kitchen Sink - Anyscale Memorystore Port |
| <a name="output_kitchen_sink_anyscale_memorystore_region"></a> [kitchen\_sink\_anyscale\_memorystore\_region](#output\_kitchen\_sink\_anyscale\_memorystore\_region) | Kitchen Sink - Anyscale Memorystore Region |
| <a name="output_test_no_resources"></a> [test\_no\_resources](#output\_test\_no\_resources) | The outputs of the no\_resource resource - should be empty |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
