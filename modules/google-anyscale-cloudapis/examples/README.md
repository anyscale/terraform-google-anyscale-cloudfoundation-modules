# google-anyscale-apis examples

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 6.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_all_defaults"></a> [all\_defaults](#module\_all\_defaults) | ../ | n/a |
| <a name="module_kitchen_sink"></a> [kitchen\_sink](#module\_kitchen\_sink) | ../ | n/a |
| <a name="module_test_no_resources"></a> [test\_no\_resources](#module\_test\_no\_resources) | ../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_google_project_id"></a> [google\_project\_id](#input\_google\_project\_id) | ID of the Project to put these resources in | `string` | n/a | yes |
| <a name="input_google_region"></a> [google\_region](#input\_google\_region) | The Google region in which all resources will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_default_enabled_apis"></a> [all\_default\_enabled\_apis](#output\_all\_default\_enabled\_apis) | Enabled APIs for All Defaults |
| <a name="output_kitchen_sink_enabled_apis"></a> [kitchen\_sink\_enabled\_apis](#output\_kitchen\_sink\_enabled\_apis) | Enabled APIs for Kitchen Sink |
| <a name="output_test_no_resources"></a> [test\_no\_resources](#output\_test\_no\_resources) | The outputs of the no\_resource resource - should be empty |
<!-- END_TF_DOCS -->
