[![Build Status][badge-build]][build-status]
[![Terraform Version][badge-terraform]](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version][badge-tf-google]](https://github.com/terraform-providers/terraform-provider-google/releases)
# google-anyscale-cloudstorage examples

There are three examples:
- all_defaults
- kitchen_sink
- test_no_resources

There are only 3 required variables:
- `google_project_id` - a project ID for the new cloudstorage bucket.
- `anyscale_deploy_env` - this is used for unit tests to make sure resources aren't automatically removed.
- `google_region` - this specifies the region to execute in

## all_defaults
This builds a cloudstorage bucket using as many defaults as possible.

## kitchen_sink
This builds a cloudstorage bucket by passing in as many variables as possible. It references the `all_defaults` bucket for logging purposes.

## test_no_resources
This should NOT build any cloudstorage resources and is here for unit testing.

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
| <a name="module_kitchen_sink_iam"></a> [kitchen\_sink\_iam](#module\_kitchen\_sink\_iam) | ../../google-anyscale-iam | n/a |
| <a name="module_test_no_resources"></a> [test\_no\_resources](#module\_test\_no\_resources) | ../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID | `string` | `null` | no |
| <a name="input_anyscale_deploy_env"></a> [anyscale\_deploy\_env](#input\_anyscale\_deploy\_env) | (Required) Anyscale deploy environment. Used in resource names and tags. | `string` | n/a | yes |
| <a name="input_google_project_id"></a> [google\_project\_id](#input\_google\_project\_id) | ID of the Project to put these resources in. | `string` | n/a | yes |
| <a name="input_google_region"></a> [google\_region](#input\_google\_region) | The Google region in which all resources will be created. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) A map of tags to all resources that accept tags. | `map(string)` | <pre>{<br>  "environment": "test",<br>  "test": true<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_defaults_bucketname"></a> [all\_defaults\_bucketname](#output\_all\_defaults\_bucketname) | The name of the all defaults anyscale resource. |
| <a name="output_all_defaults_selflink"></a> [all\_defaults\_selflink](#output\_all\_defaults\_selflink) | The selflink of the anyscale resource. |
| <a name="output_all_defaults_url"></a> [all\_defaults\_url](#output\_all\_defaults\_url) | The URL of the anyscale resource. |
| <a name="output_kitchen_sink_bucketname"></a> [kitchen\_sink\_bucketname](#output\_kitchen\_sink\_bucketname) | The name for the kitchen sink anyscale resource. |
| <a name="output_kitchen_sink_selflink"></a> [kitchen\_sink\_selflink](#output\_kitchen\_sink\_selflink) | The selflink of the kitchen sink anyscale resource. |
| <a name="output_kitchen_sink_url"></a> [kitchen\_sink\_url](#output\_kitchen\_sink\_url) | The URL of the kitchen sink anyscale resource. |
| <a name="output_test_no_resources"></a> [test\_no\_resources](#output\_test\_no\_resources) | The outputs of the no\_resource resource - should all be empty |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- References -->
[Terraform]: https://www.terraform.io
[Issues]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-tf-aws]: https://img.shields.io/badge/AWS-4.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/actions
