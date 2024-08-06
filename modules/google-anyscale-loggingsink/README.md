[![Build Status][badge-build]][build-status]
[![Terraform Version][badge-terraform]](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version][badge-tf-google]](https://github.com/terraform-providers/terraform-provider-google/releases)
# google-anyscale-loggingsink

This sub-module modifies the `_Default` logging sink to disable syslog logging. The sub-module should be used from the [root module](../../README.md).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.38.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_logging_project_sink.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_project_sink) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_project_id"></a> [anyscale\_project\_id](#input\_anyscale\_project\_id) | (Optional) The ID of the project to create the resource in.<br><br>If not provided, the provider project is used.<br><br>ex:<pre>anyscale_project_id = "my-project"</pre> | `string` | `null` | no |
| <a name="input_module_enabled"></a> [module\_enabled](#input\_module\_enabled) | (Optional) Determines whether to create the resources inside this module.<br><br>ex:<pre>module_enabled = true</pre> | `bool` | `true` | no |
| <a name="input_sink_destination"></a> [sink\_destination](#input\_sink\_destination) | (Optional) The destination for the sink.<br><br>ex:<pre>sink_destination = "pubsub.googleapis.com/projects/my-project/topics/my-topic"</pre> | `string` | `null` | no |
| <a name="input_sink_exclusion_filter"></a> [sink\_exclusion\_filter](#input\_sink\_exclusion\_filter) | (Optional) The filter for the sink.<br><br>ex:<pre>sink_filter = "resource.type=gce_instance AND logName=projects/example/logs/syslog"</pre> | `string` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- References -->
[Terraform]: https://www.terraform.io
[Issues]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-tf-google]: https://img.shields.io/badge/GCP-5.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/actions
