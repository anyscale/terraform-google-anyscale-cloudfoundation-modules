[![Build Status][badge-build]][build-status]
[![Terraform Version][badge-terraform]](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version][badge-tf-google]](https://github.com/terraform-providers/terraform-provider-google/releases)
# google-anyscale-vpc

This builds a VPC to support Anyscale on Google Cloud.
This includes:
- The VPC Network Resource
- A public or private subnet
- ...

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.84.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_network.anyscale_vpc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_compute_subnetwork.anyscale_private_subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.anyscale_proxy_subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.anyscale_public_subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [random_id.random_char_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [time_sleep.creation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_project_id"></a> [anyscale\_project\_id](#input\_anyscale\_project\_id) | (Optional) The ID of the project to create the resource in.<br><br>If it is not provided, the provider project is used.<br><br>ex:<pre>anyscale_project_id = "gcp_anyscale"</pre> | `string` | `null` | no |
| <a name="input_anyscale_vpc_name"></a> [anyscale\_vpc\_name](#input\_anyscale\_vpc\_name) | (Optional) The name of the VPC.<br><br>This overrides the `anyscale_vpc_prefix` parameter.<br><br>ex:<pre>anyscale_vpc_name = "anyscale-vpc"</pre> | `string` | `null` | no |
| <a name="input_anyscale_vpc_name_prefix"></a> [anyscale\_vpc\_name\_prefix](#input\_anyscale\_vpc\_name\_prefix) | (Optional) The prefix of the VPC name.<br><br>Creates a unique VPC name beginning with the specified prefix.<br><br>ex:<pre>anyscale_vpc_name_prefix = "anyscale-vpc"</pre> | `string` | `"anyscale-"` | no |
| <a name="input_auto_create_subnets"></a> [auto\_create\_subnets](#input\_auto\_create\_subnets) | (Optional) Determines if the network is created in 'auto subnet mode'.<br><br>If set to `true`, a subnet will be created for each region automatically across the 10.128.0.0/9 address range.<br>When set to false, the network is created in 'custom subnet mode' so the user can explicitly create subnetwork resources.<br><br>ex:<pre>auto_create_subnets = true</pre> | `bool` | `false` | no |
| <a name="input_create_nat"></a> [create\_nat](#input\_create\_nat) | (Optional) Whether to create a NAT gateway.<br><br>Also requires `private_subnet_cidr` to be set.<br><br>ex:<pre>create_nat = true</pre> | `bool` | `true` | no |
| <a name="input_delete_default_internet_gateway_routes"></a> [delete\_default\_internet\_gateway\_routes](#input\_delete\_default\_internet\_gateway\_routes) | (Optional) Determines if all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted.<br><br>ex:<pre>delete_default_internet_gateway_routes = true</pre> | `bool` | `false` | no |
| <a name="input_enable_random_name_suffix"></a> [enable\_random\_name\_suffix](#input\_enable\_random\_name\_suffix) | (Optional) Determines if a suffix of random characters will be added to the Anyscale resources.<br><br>ex:<pre>enable_random_name_suffix = true</pre> | `bool` | `true` | no |
| <a name="input_existing_private_subnet_id"></a> [existing\_private\_subnet\_id](#input\_existing\_private\_subnet\_id) | (Optional) The existing private subnet ID to use.<br><br>This VPC terraform will only create subnets in one region.<br><br>ex:<pre>existing_private_subnet_id = "projects/anyscale/regions/us-central1/subnetworks/subnet-1"</pre> | `string` | `null` | no |
| <a name="input_existing_public_subnet_id"></a> [existing\_public\_subnet\_id](#input\_existing\_public\_subnet\_id) | (Optional) The existing public subnet ID to use.<br><br>This VPC terraform will only create subnets in one region.<br><br>ex:<pre>existing_public_subnet_id = "projects/anyscale/regions/us-central1/subnetworks/subnet-1"</pre> | `string` | `null` | no |
| <a name="input_google_region"></a> [google\_region](#input\_google\_region) | (Optional) The Google region in which all resources will be created.<br><br>If not provided, the provider region is used.<br><br>ex:<pre>google_region = "us-central1"</pre> | `string` | `null` | no |
| <a name="input_module_enabled"></a> [module\_enabled](#input\_module\_enabled) | (Optional) Determines whether to create the resources inside this module.<br><br>ex:<pre>module_enabled = true</pre> | `bool` | `true` | no |
| <a name="input_nat_enable_endpoint_independent_mapping"></a> [nat\_enable\_endpoint\_independent\_mapping](#input\_nat\_enable\_endpoint\_independent\_mapping) | (Optional) Determines if NAT endpoint independent mapping is enabled.<br><br>ex:<pre>nat_enable_endpoint_independent_mapping = true</pre> | `bool` | `false` | no |
| <a name="input_nat_enable_logging"></a> [nat\_enable\_logging](#input\_nat\_enable\_logging) | (Optional) Determines whether or not to export logs.<br><br>ex:<pre>nat_enable_logging = true</pre> | `bool` | `false` | no |
| <a name="input_nat_icmp_idle_timeout_sec"></a> [nat\_icmp\_idle\_timeout\_sec](#input\_nat\_icmp\_idle\_timeout\_sec) | (Optional) Timeout (in seconds) for ICMP connections.<br><br>Changing this forces a new NAT to be created.<br><br>ex:<pre>nat_icmp_idle_timeout_sec = 30</pre> | `string` | `"30"` | no |
| <a name="input_nat_log_config_filter"></a> [nat\_log\_config\_filter](#input\_nat\_log\_config\_filter) | (Optional) Specifies the desired filtering of logs on this NAT.<br><br>Valid values are: `ERRORS_ONLY`, `TRANSLATIONS_ONLY`, `ALL`.<br><br>ex:<pre>nat_log_config_filter = "ALL"</pre> | `string` | `"ALL"` | no |
| <a name="input_nat_min_ports_per_vm"></a> [nat\_min\_ports\_per\_vm](#input\_nat\_min\_ports\_per\_vm) | (Optional) Minimum number of ports allocated to a VM from this NAT config.<br><br>Changing this forces a new NAT to be created.<br><br>ex:<pre>nat_min_ports_per_vm = 64</pre> | `string` | `"64"` | no |
| <a name="input_nat_name"></a> [nat\_name](#input\_nat\_name) | (Optional) The name of the NAT.<br><br>Changing this forces a new NAT to be created. If not provided, will use the `vpc-name-nat`.<br><br>ex:<pre>nat_name = "anyscale-nat"</pre> | `string` | `null` | no |
| <a name="input_nat_tcp_established_idle_timeout_sec"></a> [nat\_tcp\_established\_idle\_timeout\_sec](#input\_nat\_tcp\_established\_idle\_timeout\_sec) | (Optional) Timeout (in seconds) for TCP established connections.<br><br>Changing this forces a new NAT to be created.<br><br>ex:<pre>nat_tcp_established_idle_timeout_sec = 1200</pre> | `string` | `"1200"` | no |
| <a name="input_nat_tcp_time_wait_timeout_sec"></a> [nat\_tcp\_time\_wait\_timeout\_sec](#input\_nat\_tcp\_time\_wait\_timeout\_sec) | (Optional) Timeout (in seconds) for TCP connections that are in TIME\_WAIT state.<br><br>Changing this forces a new NAT to be created.<br><br>ex:<pre>nat_tcp_time_wait_timeout_sec = 120</pre> | `string` | `"120"` | no |
| <a name="input_nat_tcp_transitory_idle_timeout_sec"></a> [nat\_tcp\_transitory\_idle\_timeout\_sec](#input\_nat\_tcp\_transitory\_idle\_timeout\_sec) | (Optional) Timeout (in seconds) for TCP transitory connections.<br><br>Changing this forces a new NAT to be created.<br><br>ex:<pre>nat_tcp_transitory_idle_timeout_sec = 30</pre> | `string` | `"30"` | no |
| <a name="input_nat_udp_idle_timeout_sec"></a> [nat\_udp\_idle\_timeout\_sec](#input\_nat\_udp\_idle\_timeout\_sec) | (Optional) Timeout (in seconds) for UDP connections.<br><br>Changing this forces a new NAT to be created.<br><br>ex:<pre>nat_udp_idle_timeout_sec = 30</pre> | `string` | `"30"` | no |
| <a name="input_private_subnet_cidr"></a> [private\_subnet\_cidr](#input\_private\_subnet\_cidr) | (Optional) The cidr block for the private subnet being created.<br><br>This VPC terraform will only create one private subnet in one region.<br><br>ex:<pre>private_subnet_cidr = "10.100.0.0/24"</pre> | `string` | `null` | no |
| <a name="input_private_subnet_description"></a> [private\_subnet\_description](#input\_private\_subnet\_description) | (Optional) The description of the private subnet.<br><br>ex:<pre>private_subnet_description = "Private Subnet"</pre> | `string` | `null` | no |
| <a name="input_private_subnet_flow_log_config"></a> [private\_subnet\_flow\_log\_config](#input\_private\_subnet\_flow\_log\_config) | (Optional) The configuration options for private subnet flow logging.<br><br>Terraform Google Provider [documented options](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#nested_log_config)<br><br>ex:<pre>private_subnet_flow_log_config = {<br>  aggregation_interval = "INTERVAL_5_SEC"<br>  flow_sampling        = 0.5<br>  metadata             = "INCLUDE_ALL_METADATA"<br>}</pre> | `map(string)` | <pre>{<br>  "aggregation_interval": "INTERVAL_5_SEC",<br>  "flow_sampling": 0.5,<br>  "metadata": "INCLUDE_ALL_METADATA"<br>}</pre> | no |
| <a name="input_private_subnet_google_api_access"></a> [private\_subnet\_google\_api\_access](#input\_private\_subnet\_google\_api\_access) | (Optional) Determines if the private subnet has access to Google APIs.<br><br>ex:<pre>private_subnet_google_api_access = true</pre> | `bool` | `true` | no |
| <a name="input_private_subnet_ipv6_type"></a> [private\_subnet\_ipv6\_type](#input\_private\_subnet\_ipv6\_type) | (Optional) The IPv6 type of the private subnet.<br><br>Must be one of `EXTERNAL`, `INTERNAL`, or `null`.<br><br>ex:<pre>private_subnet_ipv6_type = "EXTERNAL"</pre> | `string` | `null` | no |
| <a name="input_private_subnet_name"></a> [private\_subnet\_name](#input\_private\_subnet\_name) | (Optional) Explicit name for the private subnet.<br><br>If empty, the private subnet name will be generated using the `private_subnet_suffix` and VPC Name parameters.<br><br>ex:<pre>private_subnet_name = "private-subnet"</pre> | `string` | `null` | no |
| <a name="input_private_subnet_stack_type"></a> [private\_subnet\_stack\_type](#input\_private\_subnet\_stack\_type) | (Optional) The stack type of the private subnet.<br><br>Must be one of `IPV4_ONLY` or `IPV4_IPV6`. Default is `IPV4_ONLY`.<br><br>ex:<pre>private_subnet_stack_type = "IPV4_ONLY"</pre> | `string` | `"IPV4_ONLY"` | no |
| <a name="input_private_subnet_suffix"></a> [private\_subnet\_suffix](#input\_private\_subnet\_suffix) | (Optional) The suffix of the private subnet name.<br><br>Creates a unique private subnet name ending with the specified suffix.<br><br>ex:<pre>private_subnet_suffix = "private"</pre> | `string` | `"private"` | no |
| <a name="input_proxy_subnet_cidr"></a> [proxy\_subnet\_cidr](#input\_proxy\_subnet\_cidr) | (Optional) The cidr block for the proxy subnet being created.<br><br>This VPC terraform will only create one proxy subnet in one region.<br><br>ex:<pre>proxy_subnet_cidr = "10.100.0.0/24"</pre> | `string` | `null` | no |
| <a name="input_proxy_subnet_description"></a> [proxy\_subnet\_description](#input\_proxy\_subnet\_description) | (Optional) The description of the proxy subnet.<br><br>ex:<pre>proxy_subnet_description = "Proxy Subnet"</pre> | `string` | `null` | no |
| <a name="input_proxy_subnet_name"></a> [proxy\_subnet\_name](#input\_proxy\_subnet\_name) | (Optional) Explicit name for the proxy subnet.<br><br>If empty, the public subnet name will be generated using the `proxy_subnet_name` and VPC Name parameters.<br><br>ex:<pre>proxy_subnet_name = "proxy-subnet"</pre> | `string` | `null` | no |
| <a name="input_proxy_subnet_suffix"></a> [proxy\_subnet\_suffix](#input\_proxy\_subnet\_suffix) | (Optional) The suffix of the proxy subnet name.<br><br>Creates a unique proxy subnet name ending with the specified suffix.<br><br>ex:<pre>proxy_subnet_suffix = "proxy"</pre> | `string` | `"proxy"` | no |
| <a name="input_public_subnet_cidr"></a> [public\_subnet\_cidr](#input\_public\_subnet\_cidr) | (Optional) The public subnet to create.<br><br>This VPC terraform will only create one public subnet in one region.<br><br>ex:<pre>public_subnet_cidr = "10.100.0.0/24"</pre> | `string` | `null` | no |
| <a name="input_public_subnet_description"></a> [public\_subnet\_description](#input\_public\_subnet\_description) | (Optional) The description of the public subnets.<br><br>ex:<pre>public_subnet_description = "Public Subnet"</pre> | `string` | `null` | no |
| <a name="input_public_subnet_flow_log_config"></a> [public\_subnet\_flow\_log\_config](#input\_public\_subnet\_flow\_log\_config) | (Optional) The configuration options for public subnet flow logging.<br><br>ex:<pre>public_subnet_flow_log_config = {<br>  aggregation_interval = "INTERVAL_5_SEC"<br>  flow_sampling        = 0.5<br>  metadata             = "INCLUDE_ALL_METADATA"<br>}</pre> | `map(string)` | `{}` | no |
| <a name="input_public_subnet_google_api_access"></a> [public\_subnet\_google\_api\_access](#input\_public\_subnet\_google\_api\_access) | (Optional) Determines if the public subnet has access to Google APIs.<br><br>ex:<pre>public_subnet_google_api_access = true</pre> | `bool` | `true` | no |
| <a name="input_public_subnet_ipv6_type"></a> [public\_subnet\_ipv6\_type](#input\_public\_subnet\_ipv6\_type) | (Optional) The IPv6 type of the public subnet.<br><br>Must be one of `EXTERNAL`, `INTERNAL`, or `null`.<br><br>ex:<pre>public_subnet_ipv6_type = "EXTERNAL"</pre> | `string` | `null` | no |
| <a name="input_public_subnet_name"></a> [public\_subnet\_name](#input\_public\_subnet\_name) | (Optional) Explicit name for the public subnet.<br><br>If empty, the public subnet name will be generated using the `public_subnet_suffix` parameter.<br><br>ex:<pre>public_subnet_name = "public-subnet"</pre> | `string` | `null` | no |
| <a name="input_public_subnet_stack_type"></a> [public\_subnet\_stack\_type](#input\_public\_subnet\_stack\_type) | (Optional) The stack type of the public subnet.<br><br>Must be one of `IPV4_ONLY` or `IPV4_IPV6`.<br><br>ex:<pre>public_subnet_stack_type = "IPV4_ONLY"</pre> | `string` | `"IPV4_ONLY"` | no |
| <a name="input_public_subnet_suffix"></a> [public\_subnet\_suffix](#input\_public\_subnet\_suffix) | (Optional) The suffix of the public subnet name.<br><br>Creates a unique public subnet name ending with the specified suffix.<br><br>ex:<pre>public_subnet_suffix = "public"</pre> | `string` | `"public"` | no |
| <a name="input_random_char_length"></a> [random\_char\_length](#input\_random\_char\_length) | (Optional) Sets the length of random characters to be appended as a suffix.<br><br>Depends on `enable_random_name_suffix` being set to `true`. Must be an even number, and must be at least 4.<br><br>ex:<pre>random_char_length = 4</pre> | `number` | `4` | no |
| <a name="input_router_asn"></a> [router\_asn](#input\_router\_asn) | (Optional) Router ASN.<br><br>Changing this forces a new Router to be created.<br><br>ex:<pre>router_asn = "64514"</pre> | `string` | `"64514"` | no |
| <a name="input_router_keepalive_interval"></a> [router\_keepalive\_interval](#input\_router\_keepalive\_interval) | (Optional) Router keepalive\_interval.<br><br>Changing this forces a new Router to be created.<br><br>ex:<pre>router_keepalive_interval = "10"</pre> | `string` | `"20"` | no |
| <a name="input_router_name"></a> [router\_name](#input\_router\_name) | (Optional) The name of the router.<br><br>Changing this forces a new Router to be created. If not provided, will use the `vpc-name-router`.<br><br>ex:<pre>router_name = "anyscale-router"</pre> | `string` | `null` | no |
| <a name="input_routing_mode"></a> [routing\_mode](#input\_routing\_mode) | (Optional) The network routing mode.<br><br>Must be one of `REGIONAL` or `GLOBAL`.<br><br>ex:<pre>routing_mode = "REGIONAL"</pre> | `string` | `"REGIONAL"` | no |
| <a name="input_source_subnetwork_ip_ranges_to_nat"></a> [source\_subnetwork\_ip\_ranges\_to\_nat](#input\_source\_subnetwork\_ip\_ranges\_to\_nat) | (Optional) How NAT should be configured per Subnetwork.<br><br>Valid values include: `ALL_SUBNETWORKS_ALL_IP_RANGES`, `ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES`, `LIST_OF_SUBNETWORKS`.<br>Changing this forces a new NAT to be created.<br><br>ex:<pre>source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"</pre> | `string` | `"ALL_SUBNETWORKS_ALL_IP_RANGES"` | no |
| <a name="input_vpc_description"></a> [vpc\_description](#input\_vpc\_description) | (Optional) The description of the VPC.<br><br>ex:<pre>vpc_description = "VPC for Anyscale Resources"</pre> | `string` | `"VPC for Anyscale Resources"` | no |
| <a name="input_vpc_mtu"></a> [vpc\_mtu](#input\_vpc\_mtu) | (Optional) The network MTU<br><br>If set to`0`, meaning MTU is unset, the MTU will deafult to '1460'.<br>Recommended values: 1460 (default for historic reasons), 1500 (Internet default), or 8896 (for Jumbo packets).<br>Allowed are all values in the range 1300 to 8896, inclusively.<br><br>ex:<pre>vpc_mtu = 1460</pre> | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_subnet_cidr"></a> [private\_subnet\_cidr](#output\_private\_subnet\_cidr) | The Google VPC private subnet cidr |
| <a name="output_private_subnet_id"></a> [private\_subnet\_id](#output\_private\_subnet\_id) | The Google VPC private subnet id |
| <a name="output_private_subnet_name"></a> [private\_subnet\_name](#output\_private\_subnet\_name) | The Google VPC private subnet name |
| <a name="output_private_subnet_region"></a> [private\_subnet\_region](#output\_private\_subnet\_region) | The Google VPC private subnet region |
| <a name="output_public_subnet_cidr"></a> [public\_subnet\_cidr](#output\_public\_subnet\_cidr) | The Google VPC public subnet cidr |
| <a name="output_public_subnet_id"></a> [public\_subnet\_id](#output\_public\_subnet\_id) | The Google VPC public subnet id |
| <a name="output_public_subnet_name"></a> [public\_subnet\_name](#output\_public\_subnet\_name) | The Google VPC public subnet name |
| <a name="output_public_subnet_region"></a> [public\_subnet\_region](#output\_public\_subnet\_region) | The Google VPC public subnet region |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The Google VPC id |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | The Google VPC name |
| <a name="output_vpc_selflink"></a> [vpc\_selflink](#output\_vpc\_selflink) | The Google VPC self link |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- References -->
[Terraform]: https://www.terraform.io
[Issues]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-tf-google]: https://img.shields.io/badge/GCP-4.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/actions
