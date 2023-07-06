[![Build Status][badge-build]][build-status]
[![Terraform Version][badge-terraform]](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version][badge-tf-google]](https://github.com/terraform-providers/terraform-provider-google/releases)
# google-anyscale-project
Creates a new Google Cloud Project for Anyscale Resources

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.72.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project.anyscale_project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project) | resource |
| [google_project_iam_audit_config.anyscale_project_audit_config](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_audit_config) | resource |
| [random_id.random_char_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID. Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_project_id"></a> [anyscale\_project\_id](#input\_anyscale\_project\_id) | (Optional) Google Cloud Project ID. If not provided, the `project_name_computed` local variable will be used. | `string` | `null` | no |
| <a name="input_anyscale_project_name"></a> [anyscale\_project\_name](#input\_anyscale\_project\_name) | (Optional) Google Cloud Project name. Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_project_name_prefix"></a> [anyscale\_project\_name\_prefix](#input\_anyscale\_project\_name\_prefix) | (Optional) Prefix to be used for the project name.<br>Conflicts with `anyscale_project_name`. If `anyscale_project_name` is provided, it will be used and `anyscale_project_name_prefix` will be ignored.<br>Default is `anyscale-project-`. | `string` | `"anyscale-project-"` | no |
| <a name="input_billing_account_id"></a> [billing\_account\_id](#input\_billing\_account\_id) | The ID of the billing account to associate this project with. | `string` | n/a | yes |
| <a name="input_enable_random_name_suffix"></a> [enable\_random\_name\_suffix](#input\_enable\_random\_name\_suffix) | (Optional) Determines if a suffix of random characters will be added to the Anyscale resources.<br>Default is `true` | `bool` | `true` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | (Optional) The ID of a Google Cloud Folder.<br>Conflicts with `organization_id`. If `folder_id` is provided, it will be used and `organization_id` will be ignored.<br>Changing this forces the project to be migrated to the newly specified folder.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) A map of labels to add to all resources that accept labels. | `map(string)` | `{}` | no |
| <a name="input_module_enabled"></a> [module\_enabled](#input\_module\_enabled) | (Optional) Whether to create the resources inside this module. Default is `true`. | `bool` | `true` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | (Optional) Google Cloud Organization ID.<br>Conflicts with `folder_id`. If `folder_id` is provided, it will be used and `organization_id` will be ignored.<br>Changing this forces the project to be migrated to the newly specified organization.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_random_char_length"></a> [random\_char\_length](#input\_random\_char\_length) | (Optional) Sets the length of random characters to be appended as a suffix.<br>Depends on `random_bucket_suffix` being set to `true`.<br>Must be an even number, and must be at least 4.<br>Default is `4`. | `number` | `4` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | ID of the project |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Name of the project |
| <a name="output_project_number"></a> [project\_number](#output\_project\_number) | Numeric identifier for the project |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- References -->
[Terraform]: https://www.terraform.io
[Issues]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-tf-google]: https://img.shields.io/badge/GCP-4.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/actions
