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
| <a name="module_kitchen_sink"></a> [kitchen\_sink](#module\_kitchen\_sink) | ../ | n/a |
| <a name="module_minimum_anyscale_vpc_requirements_private"></a> [minimum\_anyscale\_vpc\_requirements\_private](#module\_minimum\_anyscale\_vpc\_requirements\_private) | ../ | n/a |
| <a name="module_minimum_anyscale_vpc_requirements_public"></a> [minimum\_anyscale\_vpc\_requirements\_public](#module\_minimum\_anyscale\_vpc\_requirements\_public) | ../ | n/a |
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

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_defaults_id"></a> [all\_defaults\_id](#output\_all\_defaults\_id) | all\_defaults VPC id |
| <a name="output_all_defaults_name"></a> [all\_defaults\_name](#output\_all\_defaults\_name) | all\_defaults VPC name |
| <a name="output_all_defaults_selflink"></a> [all\_defaults\_selflink](#output\_all\_defaults\_selflink) | all\_defaults VPC cidr |
| <a name="output_minimum_vpc_private_id"></a> [minimum\_vpc\_private\_id](#output\_minimum\_vpc\_private\_id) | minimum\_vpc\_private\_subnet\_id VPC id |
| <a name="output_minimum_vpc_private_name"></a> [minimum\_vpc\_private\_name](#output\_minimum\_vpc\_private\_name) | minimum\_vpc\_private\_subnet\_name VPC name |
| <a name="output_minimum_vpc_private_subnet_cidr"></a> [minimum\_vpc\_private\_subnet\_cidr](#output\_minimum\_vpc\_private\_subnet\_cidr) | minimum\_vpc\_private\_subnet\_cidr VPC cidr |
| <a name="output_minimum_vpc_private_subnet_id"></a> [minimum\_vpc\_private\_subnet\_id](#output\_minimum\_vpc\_private\_subnet\_id) | minimum\_vpc\_private\_subnet\_id VPC id |
| <a name="output_minimum_vpc_private_subnet_name"></a> [minimum\_vpc\_private\_subnet\_name](#output\_minimum\_vpc\_private\_subnet\_name) | minimum\_vpc\_private\_subnet\_name VPC name |
| <a name="output_minimum_vpc_private_subnet_selflink"></a> [minimum\_vpc\_private\_subnet\_selflink](#output\_minimum\_vpc\_private\_subnet\_selflink) | minimum\_vpc\_private\_subnet\_selflink VPC cidr |
| <a name="output_minimum_vpc_public_id"></a> [minimum\_vpc\_public\_id](#output\_minimum\_vpc\_public\_id) | minimum\_vpc\_public\_subnet\_id VPC id |
| <a name="output_minimum_vpc_public_name"></a> [minimum\_vpc\_public\_name](#output\_minimum\_vpc\_public\_name) | minimum\_vpc\_public\_subnet\_name VPC name |
| <a name="output_minimum_vpc_public_subnet_cidr"></a> [minimum\_vpc\_public\_subnet\_cidr](#output\_minimum\_vpc\_public\_subnet\_cidr) | minimum\_vpc\_public\_subnet\_cidr VPC cidr |
| <a name="output_minimum_vpc_public_subnet_id"></a> [minimum\_vpc\_public\_subnet\_id](#output\_minimum\_vpc\_public\_subnet\_id) | minimum\_vpc\_public\_subnet\_id VPC id |
| <a name="output_minimum_vpc_public_subnet_name"></a> [minimum\_vpc\_public\_subnet\_name](#output\_minimum\_vpc\_public\_subnet\_name) | minimum\_vpc\_public\_subnet\_name VPC name |
| <a name="output_minimum_vpc_public_subnet_selflink"></a> [minimum\_vpc\_public\_subnet\_selflink](#output\_minimum\_vpc\_public\_subnet\_selflink) | minimum\_vpc\_public\_subnet\_selflink VPC cidr |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- References -->
[Terraform]: https://www.terraform.io
[Issues]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-tf-aws]: https://img.shields.io/badge/AWS-4.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/actions
