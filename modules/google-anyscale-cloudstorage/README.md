[![Build Status][badge-build]][build-status]
[![Terraform Version][badge-terraform]](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version][badge-tf-google]](https://github.com/terraform-providers/terraform-provider-google/releases)
# google-anyscale-cloudstorage

This builds the Google Cloudstorage bucket used by Anyscale.

See the examples folder for how to use.

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
| <a name="provider_google"></a> [google](#provider\_google) | 4.62.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_storage_bucket.anyscale_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_binding.anyscale_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_binding) | resource |
| [random_id.random_char_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_bucket_name"></a> [anyscale\_bucket\_name](#input\_anyscale\_bucket\_name) | (Optional - forces new resource)<br>The name of the bucket.<br>Changing this forces creating a new bucket.<br>This overrides the `anyscale_bucket_name_prefix` parameter.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_bucket_name_prefix"></a> [anyscale\_bucket\_name\_prefix](#input\_anyscale\_bucket\_name\_prefix) | (Optional - forces new resource)<br>Creates a unique bucket name beginning with the specified prefix.<br>Changing this forces creating a new bucket.<br>If `anyscale_bucket_name` is provided, it overrides this parameter.<br>Default is `anyscale-`. | `string` | `"anyscale-"` | no |
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID. Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_project_id"></a> [anyscale\_project\_id](#input\_anyscale\_project\_id) | (Optional) The ID of the project to create the resource in. If not provided, the provider project is used. Default is `null`. | `string` | `null` | no |
| <a name="input_bucket_encryption_key_name"></a> [bucket\_encryption\_key\_name](#input\_bucket\_encryption\_key\_name) | (Optional) The encryption key name that should be used to encrypt this bucket. Default is `null`. | `string` | `null` | no |
| <a name="input_bucket_force_destroy"></a> [bucket\_force\_destroy](#input\_bucket\_force\_destroy) | (Optional) Determines if the contents of the bucket will be deleted when a `terraform destroy` command is issued. Default is `false`. | `bool` | `false` | no |
| <a name="input_bucket_iam_binding_members"></a> [bucket\_iam\_binding\_members](#input\_bucket\_iam\_binding\_members) | (Optional) List of members to add to the bucket IAM binding.<br>Default is an empty list. | `list(string)` | `[]` | no |
| <a name="input_bucket_iam_binding_override_roles"></a> [bucket\_iam\_binding\_override\_roles](#input\_bucket\_iam\_binding\_override\_roles) | (Optional) List of roles to override in the bucket IAM binding.<br>Default is an empty list. | `list(string)` | `[]` | no |
| <a name="input_bucket_iam_binding_roles"></a> [bucket\_iam\_binding\_roles](#input\_bucket\_iam\_binding\_roles) | (Optional) List of roles to add to the bucket IAM binding.<br>Default is `["roles/storage.objectAdmin", "roles/storage.legacyBucketReader"]` | `list(string)` | <pre>[<br>  "roles/storage.objectAdmin",<br>  "roles/storage.legacyBucketReader"<br>]</pre> | no |
| <a name="input_bucket_location"></a> [bucket\_location](#input\_bucket\_location) | (Optional) A valid GCS location to create the bucket in. Default is `US`. | `string` | `"US"` | no |
| <a name="input_bucket_logging"></a> [bucket\_logging](#input\_bucket\_logging) | (Optional) Map of bucket logging config object.<br>Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#logging<br>Default is an empty map. | `any` | `{}` | no |
| <a name="input_bucket_public_access_prevention"></a> [bucket\_public\_access\_prevention](#input\_bucket\_public\_access\_prevention) | (Optional) Determines if public access prevention is `enforced` or `inherited`. Default is `enforced`. | `string` | `"enforced"` | no |
| <a name="input_bucket_storage_class"></a> [bucket\_storage\_class](#input\_bucket\_storage\_class) | (Optional)<br>The bucket storage class.<br>Must be one of: STANDARD, MULTI\_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE<br>Default is `STANDARD` | `string` | `"STANDARD"` | no |
| <a name="input_bucket_uniform_level_access"></a> [bucket\_uniform\_level\_access](#input\_bucket\_uniform\_level\_access) | (Optional) Determines if the bucket will have uniform bucket-level access. Default is `true`. | `bool` | `true` | no |
| <a name="input_bucket_versioning"></a> [bucket\_versioning](#input\_bucket\_versioning) | (Optional) Determines if object versioning is enabled on the bucket.<br>If enabled, consider also using a object lifecycle to remove older versions after a period of time.<br>Default is `false`. | `bool` | `false` | no |
| <a name="input_cors_rules"></a> [cors\_rules](#input\_cors\_rules) | (Optional) List of CORS rules to configure.<br>Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#cors except max\_age\_seconds should be a number.<br>Default is:<br>[<br>  {<br>    origins          = ["https://console.anyscale.com"]<br>    methods          = ["GET"]<br>    response\_headers = ["*"]<br>    max\_age\_seconds  = 3600<br>  }<br>] | <pre>set(object({<br>    # Object with keys:<br>    # - origins - (Required) List of values, with wildcards, of the Origin header in the request that an incoming OPTIONS request will be matched against.<br>    # - methods - (Required) Lilst of values, with wildcards, of the Access-Control-Request-Method header in the request that an incoming OPTIONS request will be matched against.<br>    # - response_headers - (Required) List of values, with wildcards, of the Access-Control-Request-Headers header in the request that an incoming OPTIONS request will be matched against.<br>    # - max_age_seconds - (Optional) The value, in seconds, to return in the Access-Control-Max-Age header used in preflight responses.<br>    origins          = list(string)<br>    methods          = list(string)<br>    response_headers = list(string)<br>    max_age_seconds  = number<br>  }))</pre> | <pre>[<br>  {<br>    "max_age_seconds": 3600,<br>    "methods": [<br>      "GET"<br>    ],<br>    "origins": [<br>      "https://console.anyscale.com"<br>    ],<br>    "response_headers": [<br>      "*"<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_enable_random_name_suffix"></a> [enable\_random\_name\_suffix](#input\_enable\_random\_name\_suffix) | (Optional) Determines if a suffix of random characters will be added to the `anyscale_bucket_prefix` or `anyscale_bucket_name`.<br>Default is `true` | `bool` | `true` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) A map of labels to all resources that accept labels. Default is an empty map. | `map(string)` | `{}` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | (Optional) List of lifecycle rules to configure.<br>Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#lifecycle_rule except condition.matches\_storage\_class should be a comma delimited string.<br>Default is an empty list. | <pre>set(object({<br>    # Object with keys:<br>    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.<br>    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.<br>    action = map(string)<br><br>    # Object with keys:<br>    # - age - (Optional) Minimum age of an object in days to satisfy this condition.<br>    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.<br>    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".<br>    # - matches_storage_class - (Optional) Comma delimited string for storage class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.<br>    # - matches_prefix - (Optional) One or more matching name prefixes to satisfy this condition.<br>    # - matches_suffix - (Optional) One or more matching name suffixes to satisfy this condition.<br>    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.<br>    # - custom_time_before - (Optional) A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when the customTime metadata for the object is set to an earlier date than the date used in this lifecycle condition.<br>    # - days_since_custom_time - (Optional) The number of days from the Custom-Time metadata attribute after which this condition becomes true.<br>    # - days_since_noncurrent_time - (Optional) Relevant only for versioned objects. Number of days elapsed since the noncurrent timestamp of an object.<br>    # - noncurrent_time_before - (Optional) Relevant only for versioned objects. The date in RFC 3339 (e.g. 2017-06-13) when the object became nonconcurrent.<br>    condition = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_module_enabled"></a> [module\_enabled](#input\_module\_enabled) | (Optional) Whether to create the resources inside this module. Default is `true`. | `bool` | `true` | no |
| <a name="input_random_char_length"></a> [random\_char\_length](#input\_random\_char\_length) | (Optional) Sets the length of random characters to be appended as a suffix.<br>Depends on `random_bucket_suffix` being set to `true`.<br>Must be an even number, and must be at least 4.<br>Default is `4`. | `number` | `4` | no |
| <a name="input_retention_policy"></a> [retention\_policy](#input\_retention\_policy) | (Optional)<br>Object containing a retention policy including `is_locked` and `retention_period`.<br>Default is an empty map. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudstorage_bucket_name"></a> [cloudstorage\_bucket\_name](#output\_cloudstorage\_bucket\_name) | The Google Cloud Storage bucket name. |
| <a name="output_cloudstorage_bucket_selflink"></a> [cloudstorage\_bucket\_selflink](#output\_cloudstorage\_bucket\_selflink) | The Google Cloud Storage self link. |
| <a name="output_cloudstorage_bucket_url"></a> [cloudstorage\_bucket\_url](#output\_cloudstorage\_bucket\_url) | The Google Cloud Storage url for the bucket. Will be in the format `gs://<bucket-name>`. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- References -->
[Terraform]: https://www.terraform.io
[Issues]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-tf-google]: https://img.shields.io/badge/GCP-4.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/actions
