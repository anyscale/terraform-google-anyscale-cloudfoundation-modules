[![Build Status][badge-build]][build-status]
[![Terraform Version][badge-terraform]](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version][badge-tf-google]](https://github.com/terraform-providers/terraform-provider-google/releases)
# google-anyscale-cloud-apis

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.84.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project_service.anycale_compute_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.anyscale_optional_apis](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.anyscale_required_apis](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_activate_optional_apis"></a> [anyscale\_activate\_optional\_apis](#input\_anyscale\_activate\_optional\_apis) | (Optional) Optional APIs to activate.<br><br>A list of optional apis to activate within the project.<br><br>ex:<pre>anyscale_activate_optional_apis = [<br>  "cloudkms.googleapis.com",<br>  "containerregistry.googleapis.com",<br>  "logging.googleapis.com",<br>  "monitoring.googleapis.com",<br>  "redis.googleapis.com",<br>]</pre> | `list(string)` | `[]` | no |
| <a name="input_anyscale_activate_required_apis"></a> [anyscale\_activate\_required\_apis](#input\_anyscale\_activate\_required\_apis) | (Optional) The list of apis to activate within the project.<br>Default enables APIs for compute, filestore, and storage. | `list(string)` | <pre>[<br>  "compute.googleapis.com",<br>  "file.googleapis.com",<br>  "storage-component.googleapis.com",<br>  "storage.googleapis.com",<br>  "certificatemanager.googleapis.com",<br>  "cloudresourcemanager.googleapis.com",<br>  "serviceusage.googleapis.com",<br>  "deploymentmanager.googleapis.com"<br>]</pre> | no |
| <a name="input_anyscale_project_id"></a> [anyscale\_project\_id](#input\_anyscale\_project\_id) | (Optional) The ID of the project to create the resource in. If not provided, the provider project is used. Default is `null`. | `string` | `null` | no |
| <a name="input_disable_dependent_services"></a> [disable\_dependent\_services](#input\_disable\_dependent\_services) | (Optional) Determines if services that are enabled and which depend on this service should also be disabled when this service is destroyed.<br>More information in the [terraform documentation](https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_dependent_services). | `bool` | `true` | no |
| <a name="input_disable_services_on_destroy"></a> [disable\_services\_on\_destroy](#input\_disable\_services\_on\_destroy) | (Optional) Determines if project services will be disabled when the resources are destroyed.<br>More information in the [terraform documentation](https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_on_destroy).<br>Default is `true`. | `bool` | `true` | no |
| <a name="input_module_enabled"></a> [module\_enabled](#input\_module\_enabled) | (Optional) Determines whether to create the resources inside this module. Default is `true`. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_enabled_apis"></a> [enabled\_apis](#output\_enabled\_apis) | Enabled APIs in the project |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- References -->
[Terraform]: https://www.terraform.io
[Issues]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-tf-google]: https://img.shields.io/badge/GCP-4.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/actions
