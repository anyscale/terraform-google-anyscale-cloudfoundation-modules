[![Build Status][badge-build]][build-status]
[![Terraform Version][badge-terraform]](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version][badge-tf-google]](https://github.com/terraform-providers/terraform-provider-google/releases)
# google-anyscale-gke

This sub-module provides an opinionated method for creating a GKE cluster for the Anyscale Platform.

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
| <a name="provider_google"></a> [google](#provider\_google) | 5.44.2 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_container_cluster.anyscale_dataplane_autopilot](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_cluster.anyscale_dataplane_standard](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [random_id.random_char_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_shuffle.available_zones](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_compute_zones.available](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) | data source |
| [google_container_engine_versions.region](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_engine_versions) | data source |
| [google_container_engine_versions.zone](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_engine_versions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_ip_range_names_pods"></a> [additional\_ip\_range\_names\_pods](#input\_additional\_ip\_range\_names\_pods) | List of _names_ of the additional secondary subnet ip ranges to use for pods<br/>in the Anyscale GKE cluster.<br/><br/>ex:<pre>additional_ip_range_names_pods = ["anyscale-pods-2", "anyscale-pods-3"]</pre> | `list(string)` | `[]` | no |
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID<br/><br/>ex:<pre>anyscale_cloud_id = "cld_1234567890"</pre> | `string` | `null` | no |
| <a name="input_anyscale_project_id"></a> [anyscale\_project\_id](#input\_anyscale\_project\_id) | (Required) The ID of the project to create the resource in. If not provided, the provider project is used.<br/><br/>ex:<pre>anyscale_project_id = "my-project-id-142323"</pre> | `string` | n/a | yes |
| <a name="input_default_node_pool_initial_node_count"></a> [default\_node\_pool\_initial\_node\_count](#input\_default\_node\_pool\_initial\_node\_count) | (Optional) The number of nodes to create in this cluster's default node pool.<br/><br/>ex:<pre>default_node_pool_initial_node_count = 3</pre> | `number` | `1` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | (Optional) Determines whether or not to allow Terraform to destroy the cluster.<br/><br/>If set to `true`, the cluster cannot be deleted.<br/><br/>ex:<pre>deletion_protection = true</pre> | `bool` | `true` | no |
| <a name="input_enable_binary_authorization"></a> [enable\_binary\_authorization](#input\_enable\_binary\_authorization) | (Optional) Determines if binary authorization is enabled for the Anyscale GKE cluster.<br/><br/>ex:<pre>enable_binary_authorization = true</pre> | `bool` | `false` | no |
| <a name="input_enable_client_certificate"></a> [enable\_client\_certificate](#input\_enable\_client\_certificate) | (Optional) Determines if client certificate is enabled for the Anyscale GKE cluster.<br/><br/>Warning: Changing this is a destructive operation that will force your cluster to be recreated.<br/><br/>ex:<pre>enable_client_certificate = true</pre> | `bool` | `false` | no |
| <a name="input_enable_gke_autoscaling"></a> [enable\_gke\_autoscaling](#input\_enable\_gke\_autoscaling) | (Optional) Determines if autoscaling is enabled for the Anyscale GKE cluster.<br/><br/>ex:<pre>enable_gke_autoscaling = true</pre> | `bool` | `true` | no |
| <a name="input_enable_private_endpoint"></a> [enable\_private\_endpoint](#input\_enable\_private\_endpoint) | (Optional) Determines if the Anyscale GKE cluster has a private endpoint.<br/><br/>If set to `true`, the cluster will have a private endpoint.<br/><br/>ex:<pre>enable_private_endpoint = true</pre> | `bool` | `false` | no |
| <a name="input_enable_private_nodes"></a> [enable\_private\_nodes](#input\_enable\_private\_nodes) | (Optional) Determines if the Anyscale GKE nodes are private.<br/><br/>If set to `true`, the cluster will be private.<br/><br/>ex:<pre>enable_private_nodes = true</pre> | `bool` | `false` | no |
| <a name="input_enable_random_name_suffix"></a> [enable\_random\_name\_suffix](#input\_enable\_random\_name\_suffix) | (Optional) Determines if a suffix of random characters will be added to the Anyscale resources.<br/><br/>ex:<pre>enable_random_name_suffix = true</pre> | `bool` | `true` | no |
| <a name="input_enable_tpu"></a> [enable\_tpu](#input\_enable\_tpu) | (Optional) Determines if a TPU will be enabled with the Anyscale GKE cluster.<br/><br/>ex:<pre>enable_tpu = true</pre> | `bool` | `false` | no |
| <a name="input_gke_autoscaling_node_management"></a> [gke\_autoscaling\_node\_management](#input\_gke\_autoscaling\_node\_management) | (Optional) The management configuration for the Anyscale GKE cluster.<br/><br/>ex:<pre>gke_autoscaling_node_management = {<br/>  auto_repair  = true<br/>  auto_upgrade = true<br/>}</pre> | <pre>object({<br/>    auto_repair  = bool<br/>    auto_upgrade = bool<br/>  })</pre> | <pre>{<br/>  "auto_repair": true,<br/>  "auto_upgrade": true<br/>}</pre> | no |
| <a name="input_gke_autoscaling_profile"></a> [gke\_autoscaling\_profile](#input\_gke\_autoscaling\_profile) | (Optional) The autoscaling profile for the Anyscale GKE cluster.<br/><br/>Accepted values are `BALANCED`, `OPTIMISTIC`, and `CONSERVATIVE`.<br/><br/>ex:<pre>gke_autoscaling_profile = "BALANCED"</pre> | `string` | `"BALANCED"` | no |
| <a name="input_gke_autoscaling_upgrade_settings"></a> [gke\_autoscaling\_upgrade\_settings](#input\_gke\_autoscaling\_upgrade\_settings) | (Optional) The upgrade settings for the Anyscale GKE cluster.<br/><br/>ex:<pre>gke_autoscaling_upgrade_settings = {<br/>  max_surge       = 1<br/>  max_unavailable = 0<br/>  strategy        = "SURGE"<br/>}</pre> | <pre>object({<br/>    max_surge       = number<br/>    max_unavailable = number<br/>    strategy        = string<br/>  })</pre> | <pre>{<br/>  "max_surge": 1,<br/>  "max_unavailable": 0,<br/>  "strategy": "SURGE"<br/>}</pre> | no |
| <a name="input_gke_autscaling_resource_limits"></a> [gke\_autscaling\_resource\_limits](#input\_gke\_autscaling\_resource\_limits) | (Optional) The resource limits for the Anyscale GKE cluster.<br/><br/>ex:<pre>gke_autscaling_resource_limits = {<br/>  memory = {<br/>    minimum = 0<br/>    maximum = 1000000000<br/>  }<br/>  cpu = {<br/>    minimum = 0<br/>    maximum = 1000000000<br/>  }<br/>}</pre> | <pre>object({<br/>    memory = object({ minimum = number, maximum = number })<br/>    cpu    = object({ minimum = number, maximum = number })<br/>  })</pre> | <pre>{<br/>  "cpu": {<br/>    "maximum": 1000000000,<br/>    "minimum": 0<br/>  },<br/>  "memory": {<br/>    "maximum": 1000000000,<br/>    "minimum": 0<br/>  }<br/>}</pre> | no |
| <a name="input_gke_cluster_default_disk_config"></a> [gke\_cluster\_default\_disk\_config](#input\_gke\_cluster\_default\_disk\_config) | (Optional) The default disk configuration for the Anyscale GKE cluster.<br/><br/>ex:<pre>gke_cluster_default_disk_config = {<br/>  disk_type = "pd-balanced"<br/>  disk_size = 100<br/>}</pre> | <pre>object({<br/>    disk_type = string<br/>    disk_size = number<br/>  })</pre> | <pre>{<br/>  "disk_size": 500,<br/>  "disk_type": "pd-balanced"<br/>}</pre> | no |
| <a name="input_gke_cluster_description"></a> [gke\_cluster\_description](#input\_gke\_cluster\_description) | (Optional) The description of the Anyscale GKE cluster to create.<br/><br/>ex:<pre>gke_cluster_description = "Anyscale GKE Cluster"</pre> | `string` | `"Anyscale GKE Cluster"` | no |
| <a name="input_gke_cluster_gcp_iam_service_account"></a> [gke\_cluster\_gcp\_iam\_service\_account](#input\_gke\_cluster\_gcp\_iam\_service\_account) | (Optional) The GCP Service Account that will be used by the GKE Cluster when configured with Autoscaling enabled.<br/><br/>ex:<pre>gke_cluster_gcp_iam_service_account = "anyscale-cluster@anyscale-example-gke.iam.gserviceaccount.com</pre> | `string` | `null` | no |
| <a name="input_gke_cluster_ipv4_cidr"></a> [gke\_cluster\_ipv4\_cidr](#input\_gke\_cluster\_ipv4\_cidr) | (Optional) The IP range for the Anyscale GKE cluster.<br/><br/>One of `gke_cluster_ipv4_cidr` or `ip_range_name_pods` must be set.<br/><br/>ex:<pre>gke_cluster_ipv4_cidr = "10.0.2.0/24"</pre> | `string` | `null` | no |
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | (Optional) The name of the Anyscale GKE cluster to create.<br/>Conflicts with `anyscale_gke_cluster_name_prefix`.<br/>Must be unique within a project.<br/><br/>ex:<pre>gke_cluster_name = "anyscale-gke-cluster"</pre> | `string` | `null` | no |
| <a name="input_gke_cluster_name_prefix"></a> [gke\_cluster\_name\_prefix](#input\_gke\_cluster\_name\_prefix) | (Optional) The prefix of the Anyscale GKE cluster to create.<br/>Conflicts `with anyscale_gke_cluster_name`.<br/><br/>Because it is the prefix, it can end in a hyphen as it will have a random suffix appended to it.<br/><br/>ex:<pre>anyscale_gke_cluster_name_prefix = "anyscale-gke-cluster-"</pre> | `string` | `"anyscale-gke-cluster-"` | no |
| <a name="input_gke_cluster_subnet"></a> [gke\_cluster\_subnet](#input\_gke\_cluster\_subnet) | (Optional) The name of the subnet to which the filestore is attached.<br/><br/>ex:<pre>gke_cluster_subnet = "projects/anyscale-project/regions/us-central1/subnetworks/anyscale-subnet"</pre> | `string` | `null` | no |
| <a name="input_gke_cluster_type"></a> [gke\_cluster\_type](#input\_gke\_cluster\_type) | (Optional) The type of the GKE cluster to create.<br/><br/>Accepted values are `standard` and `autopilot`.<br/><br/>ex:<pre>gke_cluster_type = "standard"</pre> | `string` | `"standard"` | no |
| <a name="input_gke_cluster_vpc"></a> [gke\_cluster\_vpc](#input\_gke\_cluster\_vpc) | (Required) The name of the VPC to which the filestore is attached.<br/><br/>ex:<pre>gke_cluster_vpc = "projects/anyscale-project/global/networks/anyscale-network"</pre> | `string` | n/a | yes |
| <a name="input_gke_network_policy"></a> [gke\_network\_policy](#input\_gke\_network\_policy) | (Optional) The network policy for the Anyscale GKE cluster.<br/><br/>ex:<pre>gke_network_policy = {<br/>  enabled  = true<br/>  provider = "CALICO"<br/>}</pre> | <pre>object({<br/>    enabled  = bool<br/>    provider = string<br/>  })</pre> | `null` | no |
| <a name="input_gke_node_image_type"></a> [gke\_node\_image\_type](#input\_gke\_node\_image\_type) | (Optional) The image type for the Anyscale GKE cluster.<br/><br/>Accepted values are `COS`, `COS_CONTAINERD`, and `UBUNTU`.<br/><br/>ex:<pre>gke_node_image_type = "COS"</pre> | `string` | `"COS_CONTAINERD"` | no |
| <a name="input_gke_region"></a> [gke\_region](#input\_gke\_region) | (Optional) The region of the Anyscale GKE cluster to create.<br/><br/>Must be provided if `regional_cluster` is set to `true`.<br/><br/>ex:<pre>gke_location = "us-central1"</pre> | `string` | `null` | no |
| <a name="input_gke_services_range_cidr"></a> [gke\_services\_range\_cidr](#input\_gke\_services\_range\_cidr) | (Required) The IP range for the services in the Anyscale GKE cluster.<br/><br/>One of `gke_services_range_cidr` or `ip_range_name_services` must be set.<br/><br/>ex:<pre>gke_services_range_cidr = "10.0.1.0/24"</pre> | `string` | `null` | no |
| <a name="input_gke_zones"></a> [gke\_zones](#input\_gke\_zones) | (Optional) The zones to host the Anyscale GKE cluster in.<br/><br/>Must be provided if `regional_cluster` is set to `false`.<br/>Optional if `regional_cluster` is set to `true`.<br/><br/>ex:<pre>gke_zones = ["us-central1-a", "us-central1-b"]</pre> | `list(string)` | `[]` | no |
| <a name="input_google_region"></a> [google\_region](#input\_google\_region) | (Optional) The Google region in which all resources will be created. If not provided, the provider region is used.<br/><br/>ex:<pre>google_region = "us-central1"</pre> | `string` | `null` | no |
| <a name="input_google_zone"></a> [google\_zone](#input\_google\_zone) | (Optional) The Google zone in which all resources will be created. If not provided, the provider zone is used.<br/><br/>ex:<pre>google_zone = "us-central1"</pre> | `string` | `null` | no |
| <a name="input_ip_range_name_pods"></a> [ip\_range\_name\_pods](#input\_ip\_range\_name\_pods) | (Optional) The name of the secondary range for the pods in the Anyscale GKE cluster.<br/><br/>One of `ip_range_name_pods` or `gke_cluster_ipv4_cidr` must be set.<br/><br/>ex:<pre>ip_range_name_pods = "anyscale-pods"</pre> | `string` | `null` | no |
| <a name="input_ip_range_name_services"></a> [ip\_range\_name\_services](#input\_ip\_range\_name\_services) | (Optional) The name of the secondary range for the services in the Anyscale GKE cluster.<br/><br/>One of `ip_range_name_services` or `gke_services_range_cidr` must be set.<br/><br/>ex:<pre>ip_range_name_services = "anyscale-services"</pre> | `string` | `null` | no |
| <a name="input_kubernetes_release_channel"></a> [kubernetes\_release\_channel](#input\_kubernetes\_release\_channel) | (Optional) The release channel of this cluster.<br/><br/>Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`."<br/><br/>ex:<pre>kubernetes_release_channel = "REGULAR"</pre> | `string` | `"REGULAR"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | (Optional) The Kubernetes version.<br/><br/>If set to 'latest' it will pull latest available version in the selected region.<br/><br/>ex:<pre>kubernetes_version = "1.20.8-gke.900"</pre> | `string` | `"latest"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) A map of labels to add to all resources that accept labels.<br/><br/>ex:<pre>labels = {<br/>  "test" : true,<br/>  "env"  : "test"<br/>}</pre> | `map(string)` | `{}` | no |
| <a name="input_maintenance_end_time"></a> [maintenance\_end\_time](#input\_maintenance\_end\_time) | (Optional) Time window specified for recurring maintenance operations in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339) format.<br/><br/>ex:<pre>maintenance_end_time = "2021-01-01T06:00:00Z"</pre> | `string` | `null` | no |
| <a name="input_maintenance_exclusions"></a> [maintenance\_exclusions](#input\_maintenance\_exclusions) | (Optional) List of maintenance exclusions.<br/><br/>A cluster can have up to three.<br/><br/>ex:<pre>maintenance_exclusions = [<br/>  {<br/>    name            = "maintenance-exclusion"<br/>    start_time      = "2021-01-01T05:00:00Z"<br/>    end_time        = "2021-01-01T06:00:00Z"<br/>    exclusion_scope = "ZONE"<br/>  }<br/>]</pre> | <pre>list(<br/>    object(<br/>      {<br/>        name            = string,<br/>        start_time      = string,<br/>        end_time        = string,<br/>        exclusion_scope = string<br/>      }<br/>    )<br/>  )</pre> | `[]` | no |
| <a name="input_maintenance_recurrence"></a> [maintenance\_recurrence](#input\_maintenance\_recurrence) | (Optional) Recurrence rule for the maintenance window in [RFC5545](https://datatracker.ietf.org/doc/html/rfc5545) format.<br/><br/>If provided, `maintenance_start_time` and `maintenance_end_time` must also be provided.<br/><br/>ex:<pre>maintenance_recurrence = "FREQ=WEEKLY;BYDAY=MO"</pre> | `string` | `null` | no |
| <a name="input_maintenance_start_time"></a> [maintenance\_start\_time](#input\_maintenance\_start\_time) | (Optional) Time window specified for recurring maintenance operations in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339) format.<br/><br/>ex:<pre>maintenance_start_time = "05:00"</pre> | `string` | `"03:00"` | no |
| <a name="input_master_authorized_networks"></a> [master\_authorized\_networks](#input\_master\_authorized\_networks) | (Optional) List of master authorized networks.<br/><br/>If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists).<br/><br/>ex:<pre>master_authorized_networks = [<br/>  {<br/>    cidr_block   = "32.0.0.1/32"<br/>    display_name = "my-authorized-network"<br/>  }<br/>]</pre> | `list(object({ cidr_block = string, display_name = string }))` | `[]` | no |
| <a name="input_module_enabled"></a> [module\_enabled](#input\_module\_enabled) | (Optional) Determines whether to create the resources inside this module.<br/><br/>ex:<pre>module_enabled = true</pre> | `bool` | `false` | no |
| <a name="input_random_char_length"></a> [random\_char\_length](#input\_random\_char\_length) | (Optional) Sets the length of random characters to be appended as a suffix.<br/>Depends on `enable_random_name_suffix` being set to `true`.<br/>Must be an even number, and must be at least 4.<br/><br/>ex:<pre>random_char_length = 4</pre> | `number` | `4` | no |
| <a name="input_regional_cluster"></a> [regional\_cluster](#input\_regional\_cluster) | (Optional) Determines if the Anyscale GKE cluster is regional or zonal.<br/><br/>If set to `true`, the cluster will be regional.<br/>If set to `false`, the cluster will be zonal.<br/><br/>ex:<pre>regional_cluster = true</pre> | `bool` | `true` | no |
| <a name="input_remove_default_node_pool"></a> [remove\_default\_node\_pool](#input\_remove\_default\_node\_pool) | (Optional) Determines if the default node pool will be removed from the Anyscale GKE cluster.<br/><br/>ex:<pre>remove_default_node_pool = true</pre> | `bool` | `true` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) Timeout for cluster operations.<br/><br/>ex:<pre>timeouts = {<br/>  create = "30m"<br/>  update = "30m"<br/>  delete = "30m"<br/>}</pre> | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_anyscale_gke_cluster_endpoint"></a> [anyscale\_gke\_cluster\_endpoint](#output\_anyscale\_gke\_cluster\_endpoint) | Anyscale GKE Cluster endpoint |
| <a name="output_anyscale_gke_cluster_id"></a> [anyscale\_gke\_cluster\_id](#output\_anyscale\_gke\_cluster\_id) | Anyscale GKE Cluster ID |
| <a name="output_anyscale_gke_cluster_master_version"></a> [anyscale\_gke\_cluster\_master\_version](#output\_anyscale\_gke\_cluster\_master\_version) | Anyscale GKE Cluster master version |
| <a name="output_anyscale_gke_cluster_name"></a> [anyscale\_gke\_cluster\_name](#output\_anyscale\_gke\_cluster\_name) | Anyscale GKE Cluster name |
<!-- END_TF_DOCS -->

<!-- References -->
[Terraform]: https://www.terraform.io
[Issues]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-tf-google]: https://img.shields.io/badge/GCP-5.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/sa-terraform-google-cloudfoundation-modules/actions
