[![Build Status][badge-build]][build-status]
[![Terraform Version][badge-terraform]](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version][badge-tf-google]](https://github.com/terraform-providers/terraform-provider-google/releases)
# google-anyscale-vpc-firewall

This sub-module builds Google VPC Firewalls that will work with Anyscale. It should be used from the [root module](../../README.md).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.84.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_network_firewall_policy.anyscale_firewall_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy) | resource |
| [google_compute_network_firewall_policy_association.anyscale_firewall_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy_association) | resource |
| [google_compute_network_firewall_policy_rule.ingress_allow_from_cidr_blocks](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy_rule) | resource |
| [google_compute_network_firewall_policy_rule.ingress_allow_from_gcp_health_checks](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy_rule) | resource |
| [google_compute_network_firewall_policy_rule.ingress_from_machinepools](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy_rule) | resource |
| [google_compute_network_firewall_policy_rule.ingress_with_self](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_firewall_policy_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_project_id"></a> [anyscale\_project\_id](#input\_anyscale\_project\_id) | (Optional) The ID of the project to create the resource in.<br/><br/>If it is not provided, the provider project is used.<br/><br/>ex:<pre>anyscale_project_id = "project-1234567890"</pre> | `string` | `null` | no |
| <a name="input_default_ingress_cidr_range"></a> [default\_ingress\_cidr\_range](#input\_default\_ingress\_cidr\_range) | (Optional) List of IPv4 cidr ranges to default to if a specific mapping isn't provided.<br/><br/>ex:<pre>default_ingress_cidr_range = ["32.0.10.0/24","32.32.10.9/32"]</pre> | `list(string)` | `[]` | no |
| <a name="input_enable_firewall_rule_logging"></a> [enable\_firewall\_rule\_logging](#input\_enable\_firewall\_rule\_logging) | (Optional) Determines whether to enable logging for firewall rules.<br/><br/>ex:<pre>enable_firewall_rule_logging = true</pre> | `bool` | `true` | no |
| <a name="input_firewall_policy_description"></a> [firewall\_policy\_description](#input\_firewall\_policy\_description) | (Optional) The description of the firewall policy.<br/><br/>ex:<pre>firewall_policy_description = "Anyscale VPC Firewall Policy"</pre> | `string` | `"Anyscale VPC Firewall Policy"` | no |
| <a name="input_firewall_policy_name"></a> [firewall\_policy\_name](#input\_firewall\_policy\_name) | (Optional) The name of the firewall policy.<br/><br/>If left `null`, the firewall name will default to the vpc name.<br/><br/>ex:<pre>firewall_policy_name = "anyscale-vpc-firewall-policy"</pre> | `string` | `null` | no |
| <a name="input_ingress_from_cidr_map"></a> [ingress\_from\_cidr\_map](#input\_ingress\_from\_cidr\_map) | (Optional) List of ingress rules to create with cidr ranges.<br/>This can use rules from `predefined_firewall_rules` or custom rules.<br/><br/>ex:<pre>ingress_from_cidr_map = [<br/>  {<br/>    rule        = "https-443-tcp"<br/>    cidr_blocks = "10.100.10.10/32"<br/>  },<br/>  { rule = "nfs-tcp" },<br/>  {<br/>    ports       = "10,20,30"<br/>    protocol    = "tcp"<br/>    description = "Service name is TEST"<br/>    cidr_blocks = "10.100.10.11/32"<br/>  },<br/>  {<br/>    ports       = "82-84"<br/>    protocol    = "tcp"<br/>    description = "Service name is TEST"<br/>    cidr_blocks = "10.100.10.12/32"<br/>  }<br/>]</pre>Default is an empty list. | `list(map(string))` | `[]` | no |
| <a name="input_ingress_from_gcp_health_checks"></a> [ingress\_from\_gcp\_health\_checks](#input\_ingress\_from\_gcp\_health\_checks) | (Optional) List of ingress rules to create to allow GCP health check probes.<br/><br/>This only uses rules from `predefined_firewall_rules`.<br/>More information on GCP health checks can be found here:<br/>https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges<br/><br/>ex:<pre>ingress_from_gcp_health_checks = [<br/>  {<br/>    rule        = "health-checks"<br/>    cidr_blocks = "35.191.0.0/16, 130.211.0.0/22"<br/>  }<br/>]</pre> | `list(map(string))` | <pre>[<br/>  {<br/>    "cidr_blocks": "35.191.0.0/16,130.211.0.0/22",<br/>    "rule": "health-checks"<br/>  }<br/>]</pre> | no |
| <a name="input_ingress_from_machine_pool_cidr_ranges"></a> [ingress\_from\_machine\_pool\_cidr\_ranges](#input\_ingress\_from\_machine\_pool\_cidr\_ranges) | (Optional) List of CIDR ranges to allow ingress from machine pools.<br/><br/>ex:<pre>ingress_from_machine_pool_cidr_ranges = ["10.100.10.0/24", "10.100.11.0/24"]</pre> | `list(string)` | `[]` | no |
| <a name="input_ingress_with_self_cidr_range"></a> [ingress\_with\_self\_cidr\_range](#input\_ingress\_with\_self\_cidr\_range) | (Optional) List of CIDR range to default to if a specific mapping isn't provided.<br/><br/>ex:<pre>ingress_with_self_cidr_range = ["10.10.0.0/16","10.20.0.0/16"]</pre> | `list(string)` | `[]` | no |
| <a name="input_ingress_with_self_map"></a> [ingress\_with\_self\_map](#input\_ingress\_with\_self\_map) | (Optional) List of ingress rules to create where 'self' is defined.<br/><br/>Default rule is `all-all` as this firewall rule is used for all Anyscale resources.<br/><br/>ex:<pre>ingress_with_self_map = [<br/>  {<br/>    rule        = "https-443-tcp"<br/>  },<br/>  {<br/>    rule        = "http-80-tcp"<br/>  },<br/>  {<br/>    rule        = "ssh-tcp"<br/>  },<br/>  {<br/>    rule        = "nfs-tcp"<br/>  }<br/>]</pre> | `list(map(string))` | <pre>[<br/>  {<br/>    "rule": "all-all"<br/>  }<br/>]</pre> | no |
| <a name="input_module_enabled"></a> [module\_enabled](#input\_module\_enabled) | (Optional) Determines whether to create the resources inside this module.<br/><br/>ex:<pre>module_enabled = true</pre> | `bool` | `true` | no |
| <a name="input_predefined_firewall_rules"></a> [predefined\_firewall\_rules](#input\_predefined\_firewall\_rules) | (Required) Map of predefined firewall rules. | <pre>map(object({<br/>    ports       = string<br/>    protocol    = string<br/>    description = string<br/>    priority    = number<br/>  }))</pre> | <pre>{<br/>  "all-all": {<br/>    "description": "All protocols",<br/>    "ports": "",<br/>    "priority": 1000,<br/>    "protocol": "all"<br/>  },<br/>  "health-checks": {<br/>    "description": "Health Checks",<br/>    "ports": "8000",<br/>    "priority": 1005,<br/>    "protocol": "tcp"<br/>  },<br/>  "http-80-tcp": {<br/>    "description": "HTTP",<br/>    "ports": "80",<br/>    "priority": 1001,<br/>    "protocol": "tcp"<br/>  },<br/>  "https-443-tcp": {<br/>    "description": "HTTPS",<br/>    "ports": "443",<br/>    "priority": 1002,<br/>    "protocol": "tcp"<br/>  },<br/>  "machine-pools": {<br/>    "description": "Machine Pools",<br/>    "ports": "80,443,1010,1012,2222,5555,5903,6379,6822-6824,6826,7878,8000,8076,8085,8201,8265-8266,8686-8687,8912,8999,9090,9092,9100,9478-9482,10002-19999",<br/>    "priority": 1011,<br/>    "protocol": "tcp"<br/>  },<br/>  "nfs-tcp": {<br/>    "description": "NFS/EFS",<br/>    "ports": "2049",<br/>    "priority": 1004,<br/>    "protocol": "tcp"<br/>  },<br/>  "ssh-tcp": {<br/>    "description": "SSH",<br/>    "ports": "22",<br/>    "priority": 1003,<br/>    "protocol": "tcp"<br/>  }<br/>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Required) The ID or SelfLink of the VPC to apply the Firewall Policy to.<br/><br/>ex:<pre>vpc_id = "projects/anyscale/global/networks/anyscale-network"</pre> | `string` | `""` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | (Required) The name of the VPC to apply the Firewall Policy to.<br/><br/>ex:<pre>vpc_name = "anyscale-vpc"</pre> | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_firewall_policy_id"></a> [vpc\_firewall\_policy\_id](#output\_vpc\_firewall\_policy\_id) | The Google VPC firewall policy id. |
| <a name="output_vpc_firewall_policy_name"></a> [vpc\_firewall\_policy\_name](#output\_vpc\_firewall\_policy\_name) | The Google VPC firewall policy name. |
| <a name="output_vpc_firewall_policy_networkfirewallpolicyid"></a> [vpc\_firewall\_policy\_networkfirewallpolicyid](#output\_vpc\_firewall\_policy\_networkfirewallpolicyid) | The Google VPC firewall policy network firewall policy id. |
| <a name="output_vpc_firewall_policy_selflink"></a> [vpc\_firewall\_policy\_selflink](#output\_vpc\_firewall\_policy\_selflink) | The Google VPC firewall policy self link. |
| <a name="output_vpc_firewall_policy_selflink_withid"></a> [vpc\_firewall\_policy\_selflink\_withid](#output\_vpc\_firewall\_policy\_selflink\_withid) | The Google VPC firewall policy self link with id. |
<!-- END_TF_DOCS -->

<!-- References -->
[Terraform]: https://www.terraform.io
[Issues]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-tf-google]: https://img.shields.io/badge/GCP-4.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/actions
