[![Build Status][badge-build]][build-status]
[![Terraform Version][badge-terraform]](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version][badge-tf-google]](https://github.com/terraform-providers/terraform-provider-google/releases)
# google-anyscale-filestore

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
| <a name="provider_google"></a> [google](#provider\_google) | 4.84.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_filestore_instance.anyscale](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/filestore_instance) | resource |
| [random_id.random_char_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Required) Anyscale Cloud ID | `string` | `null` | no |
| <a name="input_anyscale_filestore_fileshare_capacity_gb"></a> [anyscale\_filestore\_fileshare\_capacity\_gb](#input\_anyscale\_filestore\_fileshare\_capacity\_gb) | (Optional) The capacity of the fileshare to create. This must be at least 1024 GiB for the standard tier, or 2560 GiB for the premium tier. Default is `2560`. | `number` | `2560` | no |
| <a name="input_anyscale_filestore_fileshare_name"></a> [anyscale\_filestore\_fileshare\_name](#input\_anyscale\_filestore\_fileshare\_name) | (Optional) The name of the fileshare to create.<br>Conflicts with `anyscale_filestore_fileshare_name_prefix`.<br>Must start with a letter, followed by letters, numbers, or underscores, and cannot end with an underscore.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_filestore_name"></a> [anyscale\_filestore\_name](#input\_anyscale\_filestore\_name) | (Optional) The name of the filestore to create.<br>Conflicts with `anyscale_filestore_name_prefix`.<br>Must start with a lowercase letter followed by up to 62 lowercase letters, numbers, or hyphens, and cannot end with a hyphen.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_filestore_name_prefix"></a> [anyscale\_filestore\_name\_prefix](#input\_anyscale\_filestore\_name\_prefix) | (Optional) The prefix of the filestore to create.<br>Conflicts `with anyscale_filestore_name`.<br>Must start with a lowercase letter followed by up to 48 lowercase letters, numbers, or hyphens.<br>Because it is the prefix, it can end in a hyphen as it will have a random suffix appended to it.<br>Default is `anyscale-filestore-`." | `string` | `"anyscale-filestore-"` | no |
| <a name="input_anyscale_project_id"></a> [anyscale\_project\_id](#input\_anyscale\_project\_id) | (Optional) The ID of the project to create the resource in. If not provided, the provider project is used. Default is `null`. | `string` | `null` | no |
| <a name="input_enable_random_name_suffix"></a> [enable\_random\_name\_suffix](#input\_enable\_random\_name\_suffix) | (Optional) Determines if a suffix of random characters will be added to the Anyscale resources.<br>Default is `true` | `bool` | `true` | no |
| <a name="input_filestore_description"></a> [filestore\_description](#input\_filestore\_description) | (Optional) The description of the filestore to create. If anyscale\_cloud\_id is provided, "for anyscale\_cloud\_id" will be appended. Default is `Anyscale Filestore`. | `string` | `"Anyscale Filestore"` | no |
| <a name="input_filestore_location"></a> [filestore\_location](#input\_filestore\_location) | (Optional) The name of the Google Region or Availability Zone in which the filestore resource will be created.<br>For `ENTERPRISE` tier instances, this should be Region.<br>For `STANDARD`, `BASIC_HDD`, `BASIC_SSD`, and `HIGH_SCALE_SSD` tier instances, this should be Zone.<br>If it is not provided, `google_region`, `google_zone` or provider configuration is used.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_filestore_network_conect_mode"></a> [filestore\_network\_conect\_mode](#input\_filestore\_network\_conect\_mode) | (Optional) The connect modes in which the filestore will be created.<br><br>If using a shared VPC, this should be set to `PRIVATE_SERVICE_ACCESS`, otherwise it should be set to `DIRECT_PEERING`.<br><br>ex:<pre>filestore_network_conect_mode = "DIRECT_PEERING"</pre> | `string` | `"DIRECT_PEERING"` | no |
| <a name="input_filestore_network_modes"></a> [filestore\_network\_modes](#input\_filestore\_network\_modes) | (Optional) The modes in which the filestore will be created. Default is `["MODE_IPV4"]`. | `list(string)` | <pre>[<br>  "MODE_IPV4"<br>]</pre> | no |
| <a name="input_filestore_tier"></a> [filestore\_tier](#input\_filestore\_tier) | (Optional) The tier of the filestore to create. Default is `STANDARD`. | `string` | `"STANDARD"` | no |
| <a name="input_filestore_vpc_name"></a> [filestore\_vpc\_name](#input\_filestore\_vpc\_name) | (Required) The name of the VPC to which the filestore is attached. | `string` | n/a | yes |
| <a name="input_google_region"></a> [google\_region](#input\_google\_region) | (Optional) The Google region in which all resources will be created. If not provided, the provider region is used. Default is `null`. | `string` | `null` | no |
| <a name="input_google_zone"></a> [google\_zone](#input\_google\_zone) | (Optional) The Google zone in which all resources will be created. If not provided, the provider zone is used. Default is `null`. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) A map of labels to add to all resources that accept labels. | `map(string)` | `{}` | no |
| <a name="input_module_enabled"></a> [module\_enabled](#input\_module\_enabled) | (Optional) Determines whether to create the resources inside this module. Default is `true`. | `bool` | `true` | no |
| <a name="input_random_char_length"></a> [random\_char\_length](#input\_random\_char\_length) | (Optional) Sets the length of random characters to be appended as a suffix.<br>Depends on `random_bucket_suffix` being set to `true`.<br>Must be an even number, and must be at least 4.<br>Default is `4`. | `number` | `4` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_anyscale_filestore_fileshare_name"></a> [anyscale\_filestore\_fileshare\_name](#output\_anyscale\_filestore\_fileshare\_name) | Anyscale filestore fileshare name |
| <a name="output_anyscale_filestore_fileshare_source_backup"></a> [anyscale\_filestore\_fileshare\_source\_backup](#output\_anyscale\_filestore\_fileshare\_source\_backup) | Anyscale filestore fileshare source backup |
| <a name="output_anyscale_filestore_id"></a> [anyscale\_filestore\_id](#output\_anyscale\_filestore\_id) | Anyscale filestore ID |
| <a name="output_anyscale_filestore_ip_addresses"></a> [anyscale\_filestore\_ip\_addresses](#output\_anyscale\_filestore\_ip\_addresses) | Anyscale filestore IP addresses |
| <a name="output_anyscale_filestore_location"></a> [anyscale\_filestore\_location](#output\_anyscale\_filestore\_location) | Anyscale filestore location |
| <a name="output_anyscale_filestore_name"></a> [anyscale\_filestore\_name](#output\_anyscale\_filestore\_name) | Anyscale filestore name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- References -->
[Terraform]: https://www.terraform.io
[Issues]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-tf-google]: https://img.shields.io/badge/GCP-4.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/actions
