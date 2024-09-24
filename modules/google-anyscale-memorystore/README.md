[![Build Status][badge-build]][build-status]
[![Terraform Version][badge-terraform]](https://github.com/hashicorp/terraform/releases)
[![OpenTofu Version][badge-opentofu]](https://github.com/opentofu/opentofu/releases)
[![Google Provider Version][badge-tf-google]](https://github.com/terraform-providers/terraform-provider-google/releases)
# google-anyscale-memorystore

This optional sub-module that creates a Google Memorystore Redis DB. It should be used from the [root module](../../README.md).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_redis_instance.anyscale_memorystore](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance) | resource |
| [random_id.random_char_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alternative_google_zone"></a> [alternative\_google\_zone](#input\_alternative\_google\_zone) | (Optional) Alternative Google Cloud Zone<br/><br/>The alternative Google zone in which resources will be created.<br/><br/>If `alternative_google_zone is also provided, it must be different from `google\_zone`.<br/>If it is not provided, the service will choose two zones for the instances to be created in for protection against zonal failures.<br/><br/>ex:<br/>`<pre>alternative_google_zone = "us-central1-b"</pre> | `string` | `null` | no |
| <a name="input_anyscale_memorystore_name"></a> [anyscale\_memorystore\_name](#input\_anyscale\_memorystore\_name) | (Optional) The name of the memorystore to create.<br/><br/>Conflicts with `anyscale_memorystore_name_prefix`.<br/>Must start with a lowercase letter followed by up to 62 lowercase letters, numbers, or hyphens, and cannot end with a hyphen.<br/><br/>ex:<pre>anyscale_memorystore_name = "anyscale-memorystore"</pre> | `string` | `null` | no |
| <a name="input_anyscale_memorystore_name_prefix"></a> [anyscale\_memorystore\_name\_prefix](#input\_anyscale\_memorystore\_name\_prefix) | (Optional) The prefix of the memorystore to create.<br/><br/>Conflicts `with anyscale_memorystore_name`.<br/>Must start with a lowercase letter followed by up to 48 lowercase letters, numbers, or hyphens.<br/>Because it is the prefix, it can end in a hyphen as it will have a random suffix appended to it.<br/><br/>Default is `null` but set to `anyscale-memorystore-` in the module.<br/><br/>ex:<pre>anyscale_memorystore_name_prefix = "anyscale-memorystore-"</pre> | `string` | `null` | no |
| <a name="input_anyscale_project_id"></a> [anyscale\_project\_id](#input\_anyscale\_project\_id) | (Optional) Google Project ID<br/><br/>ID of the project to create the resource in. If not provided, the provider project is used.<br/><br/>ex:<pre>anyscale_project_id = "my-project"</pre> | `string` | `null` | no |
| <a name="input_enable_random_name_suffix"></a> [enable\_random\_name\_suffix](#input\_enable\_random\_name\_suffix) | (Optional) Determines if a suffix of random characters will be added to the Anyscale resources.<br/><br/>ex:<pre>enable_random_name_suffix = true</pre> | `bool` | `true` | no |
| <a name="input_google_region"></a> [google\_region](#input\_google\_region) | (Optional) Google Cloud Region<br/><br/>The Google region in which all resources will be created. If not provided, the provider region is used.<br/><br/>ex:<pre>google_region = "us-central1"</pre> | `string` | `null` | no |
| <a name="input_google_zone"></a> [google\_zone](#input\_google\_zone) | (Optional) Google Cloud Zone<br/><br/>The Google zone in which resources will be created. If not provided, the service will choose two zones for the instances to be created in for protection against zonal failures.<br/><br/>If `alternative_google_zone is also provided, it must be different from `google\_zone`.<br/><br/>ex:<br/>`<pre>google_zone = "us-central1-a"</pre> | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) Google Cloud Labels<br/><br/>A map of labels to add to all resources that accept labels.<br/><br/>ex:<pre>labels = {<br/>  "key1" = "value1"<br/>  "key2" = "value2"<br/>}</pre> | `map(string)` | `{}` | no |
| <a name="input_memorystore_connect_mode"></a> [memorystore\_connect\_mode](#input\_memorystore\_connect\_mode) | (Optional) The connection mode of the instance.<br/><br/>Must be one of `DIRECT_PEERING` or `PRIVATE_SERVICE_ACCESS`.<br/><br/>ex:<pre>memorystore_connect_mode = "DIRECT_PEERING"</pre> | `string` | `"DIRECT_PEERING"` | no |
| <a name="input_memorystore_display_name"></a> [memorystore\_display\_name](#input\_memorystore\_display\_name) | (Optional) The display name of the memorystore.<br/><br/>ex:<pre>memorystore_display_name = "Anyscale Memorystore"</pre> | `string` | `null` | no |
| <a name="input_memorystore_enable_auth"></a> [memorystore\_enable\_auth](#input\_memorystore\_enable\_auth) | (Optional) Determines if User Auth is enabled for the instance.<br/><br/>If set to true Auth is enabled on the instance.<br/><br/>ex:<pre>enable_user_auth = true</pre> | `bool` | `false` | no |
| <a name="input_memorystore_encryption_mode"></a> [memorystore\_encryption\_mode](#input\_memorystore\_encryption\_mode) | (Optional) The TLS mode of the Redis instance.<br/><br/>If not provided, TLS is enabled for the instance. Valid values are `SERVER_AUTHENTICATION` or `DISABLED`.<br/><br/>ex:<pre>transit_encryption_mode = "SERVER_AUTHENTICATION"</pre> | `string` | `"DISABLED"` | no |
| <a name="input_memorystore_maintenance_policy"></a> [memorystore\_maintenance\_policy](#input\_memorystore\_maintenance\_policy) | (Optional) The maintenance policy for an instance.<br/><br/>ex:<pre>memorystore_maintenance_policy = {<br/>  day = "MONDAY"<br/>  start_time = {<br/>    hours   = 3<br/>    minutes = 30<br/>    seconds = 0<br/>    nanos   = 0<br/>  }<br/>}</pre> | <pre>object({<br/>    day = string<br/>    start_time = object({<br/>      hours   = number<br/>      minutes = number<br/>      seconds = number<br/>      nanos   = number<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_memorystore_memory_size_gb"></a> [memorystore\_memory\_size\_gb](#input\_memorystore\_memory\_size\_gb) | (Optional) The memory size of the instance in GB.<br/><br/>Must be greater than or equal to 5 and less than or equal to 300.<br/><br/>ex:<pre>memorystore_memory_size_gb = 5</pre> | `number` | `5` | no |
| <a name="input_memorystore_persistence_config"></a> [memorystore\_persistence\_config](#input\_memorystore\_persistence\_config) | (Optional) The persistence configuration for an instance.<br/><br/>ex:<pre>memorystore_persistence_config = {<br/>  persistence_mode    = "RDB"<br/>  rdb_snapshot_period = "TWENTY_FOUR_HOURS"<br/>}</pre> | <pre>object({<br/>    persistence_mode    = string<br/>    rdb_snapshot_period = string<br/>  })</pre> | `null` | no |
| <a name="input_memorystore_redis_configs"></a> [memorystore\_redis\_configs](#input\_memorystore\_redis\_configs) | (Optional) The Redis configuration parameters.<br/><br/>ex:<pre>memorystore_redis_configs = {<br/>  "maxmemory-policy" = "allkeys-lru"<br/>}</pre> | `map(string)` | <pre>{<br/>  "maxmemory-policy": "allkeys-lru"<br/>}</pre> | no |
| <a name="input_memorystore_redis_version"></a> [memorystore\_redis\_version](#input\_memorystore\_redis\_version) | (Optional) The version of Redis software.<br/><br/>Must be one of `REDIS_5_0`, `REDIS_6_X`, or `REDIS_7_0`.<br/><br/>ex:<pre>memorystore_redis_version = "REDIS_6_X"</pre> | `string` | `"REDIS_7_0"` | no |
| <a name="input_memorystore_replica_count"></a> [memorystore\_replica\_count](#input\_memorystore\_replica\_count) | (Optional) The number of replicas to be created in the cluster.<br/><br/>Must be greater than or equal to 1 and less than or equal to 5.<br/><br/>ex:<pre>memorystore_replica_count = 1</pre> | `number` | `1` | no |
| <a name="input_memorystore_replica_mode"></a> [memorystore\_replica\_mode](#input\_memorystore\_replica\_mode) | (Optional) The replication mode of the cluster.<br/><br/>Currently, only `READ_REPLICAS_ENABLED` is supported.<br/><br/>ex:<pre>memorystore_replica_mode = "READ_REPLICAS_ENABLED"</pre> | `string` | `"READ_REPLICAS_ENABLED"` | no |
| <a name="input_memorystore_tier"></a> [memorystore\_tier](#input\_memorystore\_tier) | (Optional) The service tier of the instance.<br/><br/>Currently, only `STANDARD_HA` is supported.<br/><br/>ex:<pre>memorystore_tier = "STANDARD_HA"</pre> | `string` | `"STANDARD_HA"` | no |
| <a name="input_memorystore_vpc_name"></a> [memorystore\_vpc\_name](#input\_memorystore\_vpc\_name) | (Required) VPC Name<br/><br/>The name of the VPC to which the memorystore is attached.<br/><br/>ex:<pre>memorystore_vpc_name = "anyscale-vpc"</pre> | `string` | n/a | yes |
| <a name="input_module_enabled"></a> [module\_enabled](#input\_module\_enabled) | (Optional) Determines whether to create the resources inside this module.<br/><br/>ex:<pre>module_enabled = true</pre> | `bool` | `false` | no |
| <a name="input_random_char_length"></a> [random\_char\_length](#input\_random\_char\_length) | (Optional) Sets the length of random characters to be appended as a suffix.<br/><br/>Depends on `random_bucket_suffix` being set to `true`.<br/>Must be an even number, and must be at least 4.<br/><br/>ex:<pre>random_char_length = 4</pre> | `number` | `4` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_anyscale_memorystore_current_location_id"></a> [anyscale\_memorystore\_current\_location\_id](#output\_anyscale\_memorystore\_current\_location\_id) | The current zone where the Redis endpoint is placed. |
| <a name="output_anyscale_memorystore_host"></a> [anyscale\_memorystore\_host](#output\_anyscale\_memorystore\_host) | The IP address of the instance. |
| <a name="output_anyscale_memorystore_id"></a> [anyscale\_memorystore\_id](#output\_anyscale\_memorystore\_id) | The memorystore instance ID. |
| <a name="output_anyscale_memorystore_maintenance_schedule"></a> [anyscale\_memorystore\_maintenance\_schedule](#output\_anyscale\_memorystore\_maintenance\_schedule) | The maintenance schedule for the instance. |
| <a name="output_anyscale_memorystore_port"></a> [anyscale\_memorystore\_port](#output\_anyscale\_memorystore\_port) | The port number of the exposed Redis endpoint. |
| <a name="output_anyscale_memorystore_region"></a> [anyscale\_memorystore\_region](#output\_anyscale\_memorystore\_region) | The region the instance lives in. |
<!-- END_TF_DOCS -->

<!-- References -->
[Terraform]: https://www.terraform.io
[OpenTofu]: https://opentofu.org/
[Issues]: https://github.com/anyscale/terraform-google-anyscale-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/terraform-google-anyscale-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-opentofu]: https://img.shields.io/badge/opentofu-1.x%20-623CE4.svg?logo=terraform
[badge-tf-google]: https://img.shields.io/badge/Google-6.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/terraform-google-anyscale-cloudfoundation-modules/actions
