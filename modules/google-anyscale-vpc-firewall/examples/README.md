[![Build Status][badge-build]][build-status]
[![Terraform Version][badge-terraform]](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version][badge-tf-google]](https://github.com/terraform-providers/terraform-provider-google/releases)
# google-anyscale-vpc examples

There are three examples:
- all_defaults
- kitchen_sink
- test_no_resources

There are only 3 required variables:
- `google_project_id` - a project ID for the new cloudstorage bucket.
- `anyscale_deploy_env` - this is used for unit tests to make sure resources aren't automatically removed.
- `google_region` - this specifies the region to execute in
-
## all_defaults
This builds a VPC using as many defaults as possible.

## kitchen_sink
This builds a VPC by passing in as many variables as possible.

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
| <a name="module_all_defaults_vpc"></a> [all\_defaults\_vpc](#module\_all\_defaults\_vpc) | ../../google-anyscale-vpc | n/a |
| <a name="module_anyscale_firewall_private"></a> [anyscale\_firewall\_private](#module\_anyscale\_firewall\_private) | ../ | n/a |
| <a name="module_anyscale_firewall_private_vpc"></a> [anyscale\_firewall\_private\_vpc](#module\_anyscale\_firewall\_private\_vpc) | ../../google-anyscale-vpc | n/a |
| <a name="module_anyscale_firewall_public"></a> [anyscale\_firewall\_public](#module\_anyscale\_firewall\_public) | ../ | n/a |
| <a name="module_anyscale_firewall_public_vpc"></a> [anyscale\_firewall\_public\_vpc](#module\_anyscale\_firewall\_public\_vpc) | ../../google-anyscale-vpc | n/a |
| <a name="module_kitchen_sink"></a> [kitchen\_sink](#module\_kitchen\_sink) | ../ | n/a |
| <a name="module_kitchen_sink_vpc"></a> [kitchen\_sink\_vpc](#module\_kitchen\_sink\_vpc) | ../../google-anyscale-vpc | n/a |
| <a name="module_test_no_resources"></a> [test\_no\_resources](#module\_test\_no\_resources) | ../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID | `string` | `null` | no |
| <a name="input_anyscale_deploy_env"></a> [anyscale\_deploy\_env](#input\_anyscale\_deploy\_env) | (Required) Anyscale deploy environment. Used in resource names and tags. | `string` | n/a | yes |
| <a name="input_default_ingress_cidr_range"></a> [default\_ingress\_cidr\_range](#input\_default\_ingress\_cidr\_range) | (Optional) Default ingress CIDR range. Default is `null`. | `string` | `null` | no |
| <a name="input_google_project_id"></a> [google\_project\_id](#input\_google\_project\_id) | ID of the Project to put these resources in | `string` | n/a | yes |
| <a name="input_google_region"></a> [google\_region](#input\_google\_region) | The Google region in which all resources will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_defaults_name"></a> [all\_defaults\_name](#output\_all\_defaults\_name) | all\_defaults name |
| <a name="output_all_defaults_selflink"></a> [all\_defaults\_selflink](#output\_all\_defaults\_selflink) | all\_defaults self link |
| <a name="output_all_defualts_id"></a> [all\_defualts\_id](#output\_all\_defualts\_id) | all\_defaults id |
| <a name="output_kitchen_sink_id"></a> [kitchen\_sink\_id](#output\_kitchen\_sink\_id) | kitchen\_sink id |
| <a name="output_kitchen_sink_name"></a> [kitchen\_sink\_name](#output\_kitchen\_sink\_name) | kitchen\_sink name |
| <a name="output_kitchen_sink_selflink"></a> [kitchen\_sink\_selflink](#output\_kitchen\_sink\_selflink) | kitchen\_sink self link |
| <a name="output_test_no_resources"></a> [test\_no\_resources](#output\_test\_no\_resources) | The outputs of the no\_resource resource - should be empty |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- References -->
[Terraform]: https://www.terraform.io
[Issues]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-tf-aws]: https://img.shields.io/badge/AWS-4.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/actions
