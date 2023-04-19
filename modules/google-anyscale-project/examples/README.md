# Examples for using the google-anyscale-project module

There are three examples on using the google-anyscale-project module.

## all_defaults
The all_defaults example uses as many default values to create resources.

## kitchen_sink
The kitchen_sink example overrides as many of the default values as make sense.

## test_no_resources

This example does not create any resources or outputs.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

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
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID | `string` | `null` | no |
| <a name="input_anyscale_deploy_env"></a> [anyscale\_deploy\_env](#input\_anyscale\_deploy\_env) | (Required) Anyscale deploy environment. Used in resource names and tags. | `string` | n/a | yes |
| <a name="input_billing_account_id"></a> [billing\_account\_id](#input\_billing\_account\_id) | ID of the Billing Account for this Project | `string` | n/a | yes |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | ID of the Google Folder for this Project | `string` | n/a | yes |
| <a name="input_google_region"></a> [google\_region](#input\_google\_region) | The Google region in which all resources will be created. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) A map of tags to all resources that accept tags. | `map(string)` | <pre>{<br>  "environment": "test",<br>  "test": true<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_defaults_id"></a> [all\_defaults\_id](#output\_all\_defaults\_id) | The arn of the anyscale resource. |
| <a name="output_all_defaults_name"></a> [all\_defaults\_name](#output\_all\_defaults\_name) | The name of the anyscale resource. |
| <a name="output_all_defaults_number"></a> [all\_defaults\_number](#output\_all\_defaults\_number) | The ID of the anyscale resource. |
| <a name="output_kitchen_sink_id"></a> [kitchen\_sink\_id](#output\_kitchen\_sink\_id) | The arn of the kitchen sink anyscale resource. |
| <a name="output_kitchen_sink_name"></a> [kitchen\_sink\_name](#output\_kitchen\_sink\_name) | The Name of the anyscale resource. |
| <a name="output_kitchen_sink_number"></a> [kitchen\_sink\_number](#output\_kitchen\_sink\_number) | The ID of the kitchen sink anyscale resource. |
| <a name="output_test_no_resources"></a> [test\_no\_resources](#output\_test\_no\_resources) | The outputs of the no\_resource resource - should all be empty |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- References -->
[Terraform]: https://www.terraform.io
[Issues]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-tf-aws]: https://img.shields.io/badge/AWS-4.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/actions
