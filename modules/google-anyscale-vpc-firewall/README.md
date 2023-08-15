[![Build Status][badge-build]][build-status]
[![Terraform Version][badge-terraform]](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version][badge-tf-google]](https://github.com/terraform-providers/terraform-provider-google/releases)
# google-anyscale-vpc-firewall

This sub-module builds Google VPC Firewalls that will work with Anyscale.

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
| <a name="provider_google"></a> [google](#provider\_google) | 4.78.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_network_firewall_policy.anyscale_firewall_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy) | resource |
| [google_compute_network_firewall_policy_association.anyscale_firewall_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy_association) | resource |
| [google_compute_network_firewall_policy_rule.ingress_allow_from_cidr_blocks](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy_rule) | resource |
| [google_compute_network_firewall_policy_rule.ingress_with_self](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy_rule) | resource |
| [google_compute_network.anyscale_vpc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID. Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_project_id"></a> [anyscale\_project\_id](#input\_anyscale\_project\_id) | (Optional) The ID of the project to create the resource in. If it is not provided, the provider project is used. Default is `null`. | `string` | `null` | no |
| <a name="input_default_ingress_cidr_range"></a> [default\_ingress\_cidr\_range](#input\_default\_ingress\_cidr\_range) | (Optional) List of IPv4 cidr ranges to default to if a specific mapping isn't provided (see below example). Default is an empty list. | `list(string)` | `[]` | no |
| <a name="input_enable_firewall_rule_logging"></a> [enable\_firewall\_rule\_logging](#input\_enable\_firewall\_rule\_logging) | (Optional) Determines whether to enable logging for firewall rules. Default is `true`. | `bool` | `true` | no |
| <a name="input_firewall_policy_description"></a> [firewall\_policy\_description](#input\_firewall\_policy\_description) | (Optional) The description of the firewall policy. Default is `Anyscale VPC Firewall Policy`. | `string` | `"Anyscale VPC Firewall Policy"` | no |
| <a name="input_firewall_policy_name"></a> [firewall\_policy\_name](#input\_firewall\_policy\_name) | (Optional) The name of the firewall policy. If not provided, the firewall name will default to the vpc name. Default is `null`. | `string` | `null` | no |
| <a name="input_ingress_from_cidr_map"></a> [ingress\_from\_cidr\_map](#input\_ingress\_from\_cidr\_map) | (Optional) List of ingress rules to create with cidr ranges.<br>This can use rules from `predefined_firewall_rules` or custom rules.<br>ex:<pre>ingress_from_cidr_map = [<br>  {<br>    rule        = "https-443-tcp"<br>    cidr_blocks = "10.100.10.10/32"<br>  },<br>  { rule = "nfs-tcp" },<br>  {<br>    ports       = "10-20"<br>    protocol    = "tcp"<br>    description = "Service name is TEST"<br>    cidr_blocks = "10.100.10.10/32"<br>  }<br>]</pre>Default is an empty list. | `list(map(string))` | `[]` | no |
| <a name="input_ingress_with_self_cidr_range"></a> [ingress\_with\_self\_cidr\_range](#input\_ingress\_with\_self\_cidr\_range) | (Optional) List of CIDR range to default to if a specific mapping isn't provided. Default is an empty list. | `list(string)` | `[]` | no |
| <a name="input_ingress_with_self_map"></a> [ingress\_with\_self\_map](#input\_ingress\_with\_self\_map) | (Optional) List of ingress rules to create where 'self' is defined. Default rule is `all-all` as this firewall rule is used for all Anyscale resources. | `list(map(string))` | <pre>[<br>  {<br>    "rule": "all-all"<br>  }<br>]</pre> | no |
| <a name="input_module_enabled"></a> [module\_enabled](#input\_module\_enabled) | (Optional) Whether to create the resources inside this module. Default is `true`. | `bool` | `true` | no |
| <a name="input_predefined_firewall_rules"></a> [predefined\_firewall\_rules](#input\_predefined\_firewall\_rules) | (Required) Map of predefined firewall rules. | `map(list(any))` | <pre>{<br>  "all-all": [<br>    "",<br>    "all",<br>    "All protocols",<br>    1000<br>  ],<br>  "http-80-tcp": [<br>    80,<br>    "tcp",<br>    "HTTP",<br>    1001<br>  ],<br>  "https-443-tcp": [<br>    443,<br>    "tcp",<br>    "HTTPS",<br>    1002<br>  ],<br>  "nfs-tcp": [<br>    2049,<br>    "tcp",<br>    "NFS/EFS",<br>    1004<br>  ],<br>  "ssh-tcp": [<br>    22,<br>    "tcp",<br>    "SSH",<br>    1003<br>  ]<br>}</pre> | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | (Required) The name of the VPC to apply the Firewall Policy to. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_firewall_policy_id"></a> [vpc\_firewall\_policy\_id](#output\_vpc\_firewall\_policy\_id) | The Google VPC firewall policy id. |
| <a name="output_vpc_firewall_policy_name"></a> [vpc\_firewall\_policy\_name](#output\_vpc\_firewall\_policy\_name) | The Google VPC firewall policy name. |
| <a name="output_vpc_firewall_policy_networkfirewallpolicyid"></a> [vpc\_firewall\_policy\_networkfirewallpolicyid](#output\_vpc\_firewall\_policy\_networkfirewallpolicyid) | The Google VPC firewall policy network firewall policy id. |
| <a name="output_vpc_firewall_policy_selflink"></a> [vpc\_firewall\_policy\_selflink](#output\_vpc\_firewall\_policy\_selflink) | The Google VPC firewall policy self link. |
| <a name="output_vpc_firewall_policy_selflink_withid"></a> [vpc\_firewall\_policy\_selflink\_withid](#output\_vpc\_firewall\_policy\_selflink\_withid) | The Google VPC firewall policy self link with id. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- References -->
[Terraform]: https://www.terraform.io
[Issues]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-tf-google]: https://img.shields.io/badge/GCP-4.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/actions
