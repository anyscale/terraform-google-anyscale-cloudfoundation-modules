# google-anyscale-filestore examples

## Notes
This resource takes approximately 10 minutes to create the filestore if it's in Enterprise mode.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_all_defaults"></a> [all\_defaults](#module\_all\_defaults) | ../ | n/a |
| <a name="module_filestore_cloudapis"></a> [filestore\_cloudapis](#module\_filestore\_cloudapis) | ../../google-anyscale-cloudapis | n/a |
| <a name="module_filestore_vpc"></a> [filestore\_vpc](#module\_filestore\_vpc) | ../../google-anyscale-vpc | n/a |
| <a name="module_kitchen_sink"></a> [kitchen\_sink](#module\_kitchen\_sink) | ../ | n/a |
| <a name="module_test_no_resources"></a> [test\_no\_resources](#module\_test\_no\_resources) | ../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID | `string` | `null` | no |
| <a name="input_anyscale_deploy_env"></a> [anyscale\_deploy\_env](#input\_anyscale\_deploy\_env) | (Required) Anyscale deploy environment. Used in resource names and tags. | `string` | n/a | yes |
| <a name="input_google_project_id"></a> [google\_project\_id](#input\_google\_project\_id) | ID of the Project to put these resources in | `string` | n/a | yes |
| <a name="input_google_region"></a> [google\_region](#input\_google\_region) | The Google region in which all resources will be created. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) A map of labels to all resources that accept labels. | `map(string)` | <pre>{<br/>  "environment": "test",<br/>  "test": true<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_defaults_anyscale_filestore_fileshare_name"></a> [all\_defaults\_anyscale\_filestore\_fileshare\_name](#output\_all\_defaults\_anyscale\_filestore\_fileshare\_name) | All Defaults - Anyscale Fileshare Name |
| <a name="output_all_defaults_anyscale_filestore_fileshare_source_backup"></a> [all\_defaults\_anyscale\_filestore\_fileshare\_source\_backup](#output\_all\_defaults\_anyscale\_filestore\_fileshare\_source\_backup) | All Defaults - Anyscale Fileshare Source Backup |
| <a name="output_all_defaults_anyscale_filestore_id"></a> [all\_defaults\_anyscale\_filestore\_id](#output\_all\_defaults\_anyscale\_filestore\_id) | All Defaults - Anyscale Filestore ID |
| <a name="output_all_defaults_anyscale_filestore_ip_addresses"></a> [all\_defaults\_anyscale\_filestore\_ip\_addresses](#output\_all\_defaults\_anyscale\_filestore\_ip\_addresses) | All Defaults - Anyscale Fileshare IP Addresses |
| <a name="output_all_defaults_anyscale_filestore_location"></a> [all\_defaults\_anyscale\_filestore\_location](#output\_all\_defaults\_anyscale\_filestore\_location) | All Defaults - Anyscale Filestore Location |
| <a name="output_all_defaults_anyscale_filestore_name"></a> [all\_defaults\_anyscale\_filestore\_name](#output\_all\_defaults\_anyscale\_filestore\_name) | All Defaults - Anyscale Filestore Name |
| <a name="output_kitchen_sink_anyscale_filestore_fileshare_name"></a> [kitchen\_sink\_anyscale\_filestore\_fileshare\_name](#output\_kitchen\_sink\_anyscale\_filestore\_fileshare\_name) | All Defaults - Anyscale Fileshare Name |
| <a name="output_kitchen_sink_anyscale_filestore_fileshare_source_backup"></a> [kitchen\_sink\_anyscale\_filestore\_fileshare\_source\_backup](#output\_kitchen\_sink\_anyscale\_filestore\_fileshare\_source\_backup) | All Defaults - Anyscale Fileshare Source Backup |
| <a name="output_kitchen_sink_anyscale_filestore_id"></a> [kitchen\_sink\_anyscale\_filestore\_id](#output\_kitchen\_sink\_anyscale\_filestore\_id) | All Defaults - Anyscale Filestore ID |
| <a name="output_kitchen_sink_anyscale_filestore_ip_addresses"></a> [kitchen\_sink\_anyscale\_filestore\_ip\_addresses](#output\_kitchen\_sink\_anyscale\_filestore\_ip\_addresses) | All Defaults - Anyscale Fileshare IP Addresses |
| <a name="output_kitchen_sink_anyscale_filestore_location"></a> [kitchen\_sink\_anyscale\_filestore\_location](#output\_kitchen\_sink\_anyscale\_filestore\_location) | All Defaults - Anyscale Filestore Location |
| <a name="output_kitchen_sink_anyscale_filestore_name"></a> [kitchen\_sink\_anyscale\_filestore\_name](#output\_kitchen\_sink\_anyscale\_filestore\_name) | All Defaults - Anyscale Filestore Name |
| <a name="output_test_no_resources"></a> [test\_no\_resources](#output\_test\_no\_resources) | The outputs of the no\_resource resource - should be empty |
<!-- END_TF_DOCS -->
