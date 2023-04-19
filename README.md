[![Build Status][badge-build]][build-status]
[![Terraform Version][badge-terraform]](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version][badge-tf-google]](https://github.com/terraform-providers/terraform-provider-google/releases)

# Terraform Modules for Anyscale Cloud Foundations on Google
[Terraform] modules to manage cloud infrastructure for Anyscale. This builds the foundational cloud resources needed to run Anyscale
in a cloud environment. This module and sub-modules support Google Cloud.

**THIS IS PROVIDED AS A STARTING POINT AND IS CONSIDERED BETA**

**USE AT YOUR OWN RISK**

## Google Cloud Resources
The minimum resources needed to run Anyscale on Google are [documented here](https://docs.anyscale.com/user-guide/onboard/clouds/deploy-on-gcp).
To support this, sub-modules were created to allow easier long-term management of the resources. These include:
* google-anyscale-cloudapis - This enables the Google Cloud APIs necessary for Anyscale to work
* google-anyscale-cloudstorage - This builds a Cloud Storage bucket which is used by Anyscale to store cluster logs and shared resources.
* google-anyscale-filestore - This builds a FileStore and mount points which is used by Anyscale Workspaces
* google-anyscale-iam - This builds IAM roles and policies. One role for cross-account access from the Anyscale control plane, and one role for EC2 instance profiles.
* google-anyscale-project - This builds a base Google Project
* google-anyscale-vpc - This builds a rudamentary Google VPC
* google-anyscale-vpc-firewall - This builds the required Google VPC Firewall Policy

At a high level, every module can be disabled - however it is then up to the end user to build that particular resource. This is probably most
common with the network (VPC), but end users might also have custom CloudStorage, IAM, FileStore, etc scripts that they already want to use, or specific security
requirements that they've already implemented and just need to plug in the remaining items.

### Examples
The examples folder has a couple common use cases that have been tested. These include:

* Anyscale v2
  * anyscale-v2: Build everything with minimal parameters
  * anyscale-v2-commonname: Build everything, use a common name for all resources
  * anyscale-v2-privatenetwork: Build everything but with a private network
  * anyscale-v2-existingproject: Build everything except the project
  * anyscale-v2-existingvpc: Build everything except the VPC
  * anyscale-v2-kitchensink: Buidl everythign with as many parameters as possible

Additional examples can be requested via an [issues] ticket.

Example Cloud Register command for GCP:
```
anyscale cloud register --provider gcp  -n gce-anyscale-tf-test-1 \
--vpc-name anyscale-tf-test-1 \
--subnet-names anyscale-tf-test-1-subnet-uscentral1 \
--filestore-instance-id anyscale-tf-test-1  \
--filestore-location us-central1-a \
--anyscale-service-account-email anyscale-tf-test-1-crossacc@gcp-register-cloud-dogfood-1.iam.gserviceaccount.com \
--instance-service-account-email anyscale-tf-test-1-cluster@gcp-register-cloud-dogfood-1.iam.gserviceaccount.com \
--firewall-policy-names anyscale-tf-test-1-fw  \
--cloud-storage-bucket-name anyscale-tf-test-1 \
--region us-central1 \
--project-id gcp-register-cloud-dogfood-1 \
--provider-id projects/859081514944/locations/global/workloadIdentityPools/anyscale-tf-test-1/providers/private-cloud
```

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Known Issues/Untested

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_google_anyscale_cloudapis"></a> [google\_anyscale\_cloudapis](#module\_google\_anyscale\_cloudapis) | ./modules/google-anyscale-cloudapis | n/a |
| <a name="module_google_anyscale_cloudstorage"></a> [google\_anyscale\_cloudstorage](#module\_google\_anyscale\_cloudstorage) | ./modules/google-anyscale-cloudstorage | n/a |
| <a name="module_google_anyscale_filestore"></a> [google\_anyscale\_filestore](#module\_google\_anyscale\_filestore) | ./modules/google-anyscale-filestore | n/a |
| <a name="module_google_anyscale_iam"></a> [google\_anyscale\_iam](#module\_google\_anyscale\_iam) | ./modules/google-anyscale-iam | n/a |
| <a name="module_google_anyscale_project"></a> [google\_anyscale\_project](#module\_google\_anyscale\_project) | ./modules/google-anyscale-project | n/a |
| <a name="module_google_anyscale_vpc"></a> [google\_anyscale\_vpc](#module\_google\_anyscale\_vpc) | ./modules/google-anyscale-vpc | n/a |
| <a name="module_google_anyscale_vpc_firewall_policy"></a> [google\_anyscale\_vpc\_firewall\_policy](#module\_google\_anyscale\_vpc\_firewall\_policy) | ./modules/google-anyscale-vpc-firewall | n/a |

## Resources

| Name | Type |
|------|------|
| [random_id.common_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_compute_subnetwork.existing_vpc_subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_ssh_from_google_ui"></a> [allow\_ssh\_from\_google\_ui](#input\_allow\_ssh\_from\_google\_ui) | (Optional) Determines if SSH access is allowed from the Google UI.<br>Default is `true`. | `bool` | `true` | no |
| <a name="input_anyscale_bucket_cors_rules"></a> [anyscale\_bucket\_cors\_rules](#input\_anyscale\_bucket\_cors\_rules) | (Optional) List of CORS rules to configure.<br>Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#cors except max\_age\_seconds should be a number.<br>Default is:<br>[<br>  {<br>    origins          = ["https://console.anyscale.com"]<br>    methods          = ["GET"]<br>    response\_headers = ["*"]<br>    max\_age\_seconds  = 3600<br>  }<br>] | <pre>set(object({<br>    # Object with keys:<br>    # - origins - (Required) List of values, with wildcards, of the Origin header in the request that an incoming OPTIONS request will be matched against.<br>    # - methods - (Required) Lilst of values, with wildcards, of the Access-Control-Request-Method header in the request that an incoming OPTIONS request will be matched against.<br>    # - response_headers - (Required) List of values, with wildcards, of the Access-Control-Request-Headers header in the request that an incoming OPTIONS request will be matched against.<br>    # - max_age_seconds - (Optional) The value, in seconds, to return in the Access-Control-Max-Age header used in preflight responses.<br>    origins          = list(string)<br>    methods          = list(string)<br>    response_headers = list(string)<br>    max_age_seconds  = number<br>  }))</pre> | <pre>[<br>  {<br>    "max_age_seconds": 3600,<br>    "methods": [<br>      "GET"<br>    ],<br>    "origins": [<br>      "https://console.anyscale.com"<br>    ],<br>    "response_headers": [<br>      "*"<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_anyscale_bucket_lifecycle_rules"></a> [anyscale\_bucket\_lifecycle\_rules](#input\_anyscale\_bucket\_lifecycle\_rules) | (Optional) List of lifecycle rules to configure.<br>Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#lifecycle_rule except condition.matches\_storage\_class should be a comma delimited string.<br>Default is an empty list. | <pre>set(object({<br>    # Object with keys:<br>    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.<br>    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.<br>    action = map(string)<br><br>    # Object with keys:<br>    # - age - (Optional) Minimum age of an object in days to satisfy this condition.<br>    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.<br>    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".<br>    # - matches_storage_class - (Optional) Comma delimited string for storage class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.<br>    # - matches_prefix - (Optional) One or more matching name prefixes to satisfy this condition.<br>    # - matches_suffix - (Optional) One or more matching name suffixes to satisfy this condition.<br>    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.<br>    # - custom_time_before - (Optional) A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when the customTime metadata for the object is set to an earlier date than the date used in this lifecycle condition.<br>    # - days_since_custom_time - (Optional) The number of days from the Custom-Time metadata attribute after which this condition becomes true.<br>    # - days_since_noncurrent_time - (Optional) Relevant only for versioned objects. Number of days elapsed since the noncurrent timestamp of an object.<br>    # - noncurrent_time_before - (Optional) Relevant only for versioned objects. The date in RFC 3339 (e.g. 2017-06-13) when the object became nonconcurrent.<br>    condition = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_anyscale_bucket_location"></a> [anyscale\_bucket\_location](#input\_anyscale\_bucket\_location) | (Optional) The location of the bucket.<br>Default is `US`. | `string` | `"US"` | no |
| <a name="input_anyscale_bucket_name"></a> [anyscale\_bucket\_name](#input\_anyscale\_bucket\_name) | (Optional - forces new resource)<br>The name of the bucket used to store Anyscale related logs and other shared resources.<br>If left `null`, will default to anyscale\_bucket\_prefix.<br>If provided, overrides the anyscale\_bucket\_prefix variable.<br>Conflicts with anyscale\_bucket\_prefix.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_bucket_prefix"></a> [anyscale\_bucket\_prefix](#input\_anyscale\_bucket\_prefix) | (Optional - forces new resource)<br>Creates a unique bucket name beginning with the specified prefix.<br>If `anyscale_bucket_name` is provided, it will override this variable.<br>The variable `general_prefix` is a fall-back prefix if this is not provided.<br>Default is `null` but is set to `anyscale-` in a local variable. | `string` | `null` | no |
| <a name="input_anyscale_bucket_storage_class"></a> [anyscale\_bucket\_storage\_class](#input\_anyscale\_bucket\_storage\_class) | (Optional)<br>The bucket storage class.<br>Must be one of: STANDARD, MULTI\_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE<br>Default is `STANDARD` | `string` | `"STANDARD"` | no |
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID. Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_cluster_node_role_description"></a> [anyscale\_cluster\_node\_role\_description](#input\_anyscale\_cluster\_node\_role\_description) | (Optional) The description of the IAM role that will be created for Anyscale access.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_cluster_node_role_name"></a> [anyscale\_cluster\_node\_role\_name](#input\_anyscale\_cluster\_node\_role\_name) | (Optional - forces new resource)<br>The name of the IAM role that will be created for Anyscale cluster nodes.<br>If left `null`, will default to anyscale\_cluster\_node\_role\_name\_prefix.<br>If provided, overrides the anyscale\_cluster\_node\_role\_name\_prefix variable.<br>Conflicts with anyscale\_cluster\_node\_role\_name\_prefix.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_cluster_node_role_name_prefix"></a> [anyscale\_cluster\_node\_role\_name\_prefix](#input\_anyscale\_cluster\_node\_role\_name\_prefix) | (Optional - forces new resource)<br>Creates a unique IAM role name beginning with the specified prefix.<br>If `anyscale_cluster_node_role_name` is provided, it will override this variable.<br>The variable `general_prefix` is a fall-back prefix if this is not provided.<br>Default is `null` but is set to `anyscale-cluster-` in a local variable. | `string` | `null` | no |
| <a name="input_anyscale_deploy_env"></a> [anyscale\_deploy\_env](#input\_anyscale\_deploy\_env) | (Required) Anyscale deploy environment. Used in resource names and tags. | `string` | n/a | yes |
| <a name="input_anyscale_filestore_capacity_gb"></a> [anyscale\_filestore\_capacity\_gb](#input\_anyscale\_filestore\_capacity\_gb) | (Optional) The capacity of the fileshare in GB.<br>This must be at least 1024 GiB for the standard tier, or 2560 GiB for the premium tier.<br>Default is `2560`. | `number` | `2560` | no |
| <a name="input_anyscale_filestore_description"></a> [anyscale\_filestore\_description](#input\_anyscale\_filestore\_description) | (Optional) The description of the filestore instance.<br>Default is `Anyscale Filestore Instance`. | `string` | `"Anyscale Filestore Instance"` | no |
| <a name="input_anyscale_filestore_fileshare_name"></a> [anyscale\_filestore\_fileshare\_name](#input\_anyscale\_filestore\_fileshare\_name) | (Optional - forces new resource)<br>The name of the fileshare to create.<br>If left `null`, will default to `common_name`.<br>If `common_name` is null or over 16 chars, will default to `anyscale`.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_filestore_location"></a> [anyscale\_filestore\_location](#input\_anyscale\_filestore\_location) | (Optional) The name of the location region in which the filestore resource will be created.<br>This can be a region for `ENTERPRISE` tier instances.<br>If it is not provided, the region for the VPC network will be used<br>If a VPC network was not created, provider region is used.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_filestore_name"></a> [anyscale\_filestore\_name](#input\_anyscale\_filestore\_name) | (Optional - forces new resource)<br>The name of the filestore instance used to store Anyscale related logs and other shared resources.<br>If left `null`, will default to anyscale\_filestore\_name\_prefix.<br>If provided, overrides the anyscale\_filestore\_name\_prefix variable.<br>Conflicts with anyscale\_filestore\_name\_prefix.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_filestore_name_prefix"></a> [anyscale\_filestore\_name\_prefix](#input\_anyscale\_filestore\_name\_prefix) | (Optional - forces new resource)<br>Creates a unique filestore instance name beginning with the specified prefix.<br>If `anyscale_filestore_name` is provided, it will override this variable.<br>The variable `general_prefix` is a fall-back prefix if this is not provided.<br>Default is `null` but is set to `anyscale-` in a local variable. | `string` | `null` | no |
| <a name="input_anyscale_filestore_tier"></a> [anyscale\_filestore\_tier](#input\_anyscale\_filestore\_tier) | (Optional) The tier of the filestore to create.<br>Must be one of `STANDARD`, `BASIC_HDD`, `BASIC_SSD`, `HIGH_SCALE_SSD`, `ENTERPRISE` or `PREMIUM`.<br>Default is `ENTERPRISE`. | `string` | `"ENTERPRISE"` | no |
| <a name="input_anyscale_iam_access_role_description"></a> [anyscale\_iam\_access\_role\_description](#input\_anyscale\_iam\_access\_role\_description) | (Optional) The description of the IAM role that will be created for Anyscale access.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_iam_access_role_name"></a> [anyscale\_iam\_access\_role\_name](#input\_anyscale\_iam\_access\_role\_name) | (Optional - forces new resource)<br>The name of the IAM role that will be created for Anyscale access.<br>If left `null`, will default to anyscale\_iam\_access\_role\_name\_prefix.<br>If provided, overrides the anyscale\_iam\_access\_role\_name\_prefix variable.<br>Conflicts with anyscale\_iam\_access\_role\_name\_prefix.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_iam_access_role_name_prefix"></a> [anyscale\_iam\_access\_role\_name\_prefix](#input\_anyscale\_iam\_access\_role\_name\_prefix) | (Optional - forces new resource)<br>Creates a unique IAM role name beginning with the specified prefix.<br>If `anyscale_iam_access_role_name` is provided, it will override this variable.<br>The variable `general_prefix` is a fall-back prefix if this is not provided.<br>Default is `null` but is set to `anyscale-crossacct-` in a local variable. | `string` | `null` | no |
| <a name="input_anyscale_project_billing_account"></a> [anyscale\_project\_billing\_account](#input\_anyscale\_project\_billing\_account) | (Optional) Google Billing Account ID.<br>This is required if creating a new project.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_project_folder_id"></a> [anyscale\_project\_folder\_id](#input\_anyscale\_project\_folder\_id) | (Optional) The ID of a Google Cloud Folder.<br>Conflicts with `anyscale_project_organization_id`. If `anyscale_project_folder_id` is provided, it will be used and `anyscale_project_organization_id` will be ignored.<br>Changing this forces the project to be migrated to the newly specified folder.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_project_labels"></a> [anyscale\_project\_labels](#input\_anyscale\_project\_labels) | (Optional)<br>A map of labels to be added to the Anyscale Project.<br>ex:<pre>anyscale_project_labels = {<br>  application = "Anyscale",<br>  environment = "prod"<br>}</pre>Default is an empty map. | `map(string)` | `{}` | no |
| <a name="input_anyscale_project_name"></a> [anyscale\_project\_name](#input\_anyscale\_project\_name) | (Optional) Google Project name. Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_project_name_prefix"></a> [anyscale\_project\_name\_prefix](#input\_anyscale\_project\_name\_prefix) | (Optional) The name prefix for the project.<br>If `anyscale_project_name` is provided, it will override this variable.<br>The variable `general_prefix` is a fall-back prefix if this is not provided.<br><br>Default is `null` but is set to `anyscale-project-` in a local variable. | `string` | `null` | no |
| <a name="input_anyscale_project_organization_id"></a> [anyscale\_project\_organization\_id](#input\_anyscale\_project\_organization\_id) | (Optional) Google Cloud Organization ID.<br>Conflicts with `anyscale_project_folder_id`. If `anyscale_project_folder_id` is provided, it will be used and `organization_id` will be ignored.<br>Changing this forces the project to be migrated to the newly specified organization.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_vpc_create_natgw"></a> [anyscale\_vpc\_create\_natgw](#input\_anyscale\_vpc\_create\_natgw) | (Optional) Determines if a NAT Gateway is created.<br>`anyscale_vpc_private_subnet_cidr` must also be specified for this resource to be created.<br>Default is `true`. | `bool` | `true` | no |
| <a name="input_anyscale_vpc_description"></a> [anyscale\_vpc\_description](#input\_anyscale\_vpc\_description) | (Optional) The description of the VPC. Default is `VPC for Anyscale Resources`. | `string` | `"VPC for Anyscale Resources"` | no |
| <a name="input_anyscale_vpc_firewall_allow_access_from_cidrs"></a> [anyscale\_vpc\_firewall\_allow\_access\_from\_cidrs](#input\_anyscale\_vpc\_firewall\_allow\_access\_from\_cidrs) | (Required) Comma delimited string of IPv4 CIDR range to allow access to anyscale resources.<br>This should be the list of CIDR ranges that have access to the clusters. Public or private IPs are supported.<br>SSH and HTTPs ports will be opened to these CIDR ranges.<br>ex: "10.0.1.0/24,24.1.24.24/32" | `string` | n/a | yes |
| <a name="input_anyscale_vpc_firewall_policy_description"></a> [anyscale\_vpc\_firewall\_policy\_description](#input\_anyscale\_vpc\_firewall\_policy\_description) | (Optional) The description of the Anyscale VPC Firewall Policy.<br>Default is `Anyscale VPC Firewall Policy`. | `string` | `"Anyscale VPC Firewall Policy"` | no |
| <a name="input_anyscale_vpc_firewall_policy_name"></a> [anyscale\_vpc\_firewall\_policy\_name](#input\_anyscale\_vpc\_firewall\_policy\_name) | (Optional) The name of the Anyscale VPC Firewall Policy.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_vpc_name"></a> [anyscale\_vpc\_name](#input\_anyscale\_vpc\_name) | (Optional) VPC name. Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_vpc_name_prefix"></a> [anyscale\_vpc\_name\_prefix](#input\_anyscale\_vpc\_name\_prefix) | (Optional) The prefix of the VPC name.<br>Creates a unique VPC name beginning with the specified prefix.<br>If `anyscale_vpc_name` is provided, it will override this variable.<br>The variable `general_prefix` is a fall-back prefix if this is not provided.<br><br>Default is `null` but is set to `anyscale-vpc-` in a local variable. | `string` | `null` | no |
| <a name="input_anyscale_vpc_private_subnet_cidr"></a> [anyscale\_vpc\_private\_subnet\_cidr](#input\_anyscale\_vpc\_private\_subnet\_cidr) | (Optional) The private subnet to create.<br>The Anyscale VPC module will only create one private subnet in one region.<br>example:<br>  anyscale\_vpc\_private\_subnet\_cidr = "10.100.0.0/20"<br>We recommend a /20 or larger CIDR block, but will accept a /24 or larger with a warning.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_vpc_public_subnet_cidr"></a> [anyscale\_vpc\_public\_subnet\_cidr](#input\_anyscale\_vpc\_public\_subnet\_cidr) | (Optional) The public subnet to create.<br>This VPC terraform will only create one public subnet in one region.<br>example:<br>  anyscale\_vpc\_public\_subnet\_cidr = "10.100.0.0/20"<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_workload_identity_account_id"></a> [anyscale\_workload\_identity\_account\_id](#input\_anyscale\_workload\_identity\_account\_id) | (Optional) The AWS Account ID for Anyscale. Only use this if you are instructed to do so.<br>This will override the sub-module variable: `anyscale_aws_account_id`<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_workload_identity_pool_description"></a> [anyscale\_workload\_identity\_pool\_description](#input\_anyscale\_workload\_identity\_pool\_description) | (Optional) The description of the workload identity pool.<br>Default is `Used to provide Anyscale access from AWS.`. | `string` | `"Used to provide Anyscale access from AWS."` | no |
| <a name="input_anyscale_workload_identity_pool_display_name"></a> [anyscale\_workload\_identity\_pool\_display\_name](#input\_anyscale\_workload\_identity\_pool\_display\_name) | (Optional) The display name of the workload identity pool.<br>Must be less than or equal to 32 chars.<br>Default is `Anyscale Cross Account AWS Access`. | `string` | `"Anyscale Cross Account Access"` | no |
| <a name="input_anyscale_workload_identity_pool_name"></a> [anyscale\_workload\_identity\_pool\_name](#input\_anyscale\_workload\_identity\_pool\_name) | (Optional) The name of the workload identity pool.<br>If it is not provided, the Anyscale Access role name is used.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_workload_identity_pool_provider_name"></a> [anyscale\_workload\_identity\_pool\_provider\_name](#input\_anyscale\_workload\_identity\_pool\_provider\_name) | (Optional) The name of the workload identity pool provider.<br>If it is not provided, the Anyscale Access role name is used.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_bucket_iam_binding_override_roles"></a> [bucket\_iam\_binding\_override\_roles](#input\_bucket\_iam\_binding\_override\_roles) | (Optional) List of roles to grant to the Anyscale Service Accounts.<br>This allows you to override the defaults in the google-anyscale-cloudstorage module.<br>Default is an empty list but will be populated with the following roles via the module: ["roles/storage.objectAdmin", "roles/storage.legacyBucketReader"] | `list(string)` | `[]` | no |
| <a name="input_common_prefix"></a> [common\_prefix](#input\_common\_prefix) | (Optional)<br>A common prefix to add to resources created (where prefixes are allowed).<br>If paired with `use_common_name`, this will apply to all resources.<br>If this is not paired with `use_common_name`, this applies to:<br>  - CloudStorage Buckets<br>  - IAM Resources<br>  - Security Groups<br>Resource specific prefixes override this variable.<br>Max length is 30 characters.<br>Default is `null` | `string` | `null` | no |
| <a name="input_enable_anyscale_filestore"></a> [enable\_anyscale\_filestore](#input\_enable\_anyscale\_filestore) | (Optional) Determines if the Anyscale Filestore is created.<br>Default is `true`. | `bool` | `true` | no |
| <a name="input_enable_anyscale_gcs"></a> [enable\_anyscale\_gcs](#input\_enable\_anyscale\_gcs) | (Optional) Determines if the Anyscale Cloud Storage bucket is created.<br>Default is `true`. | `bool` | `true` | no |
| <a name="input_enable_anyscale_iam"></a> [enable\_anyscale\_iam](#input\_enable\_anyscale\_iam) | (Optional) Determines if the Anyscale IAM resources are created.<br>Default is `true`. | `bool` | `true` | no |
| <a name="input_enable_anyscale_vpc_firewall"></a> [enable\_anyscale\_vpc\_firewall](#input\_enable\_anyscale\_vpc\_firewall) | (Optional) Determines if the Anyscale VPC Firewall is created.<br>Default is `true`. | `bool` | `true` | no |
| <a name="input_enable_google_apis"></a> [enable\_google\_apis](#input\_enable\_google\_apis) | (Optional) Determines if the required Google APIs are enabled.<br>Default is `true`. | `bool` | `true` | no |
| <a name="input_existing_cloudstorage_bucket_name"></a> [existing\_cloudstorage\_bucket\_name](#input\_existing\_cloudstorage\_bucket\_name) | (Optional)<br>The name of an existing S3 bucket that you'd like to use.<br>Please make sure that it meets the minimum requirements for Anyscale including:<br>  - Bucket Policy<br>  - CORS Policy<br>  - Encryption configuration<br>Default is `null` | `string` | `null` | no |
| <a name="input_existing_filestore_instance_name"></a> [existing\_filestore\_instance\_name](#input\_existing\_filestore\_instance\_name) | (Optional)<br>The name of an existing Filestore instance that you'd like to use.<br>Default is `null` | `string` | `null` | no |
| <a name="input_existing_project_id"></a> [existing\_project\_id](#input\_existing\_project\_id) | (Optional) An existing GCP Project ID. If provided, this will skip creating resources with the Anyscale Project module. Default is `null`. | `string` | `null` | no |
| <a name="input_existing_vpc_name"></a> [existing\_vpc\_name](#input\_existing\_vpc\_name) | (Optional) An existing VPC Name.<br>If provided, this module will skip creating a new VPC with the Anyscale VPC module.<br>A Subnet ID (`existing_vpc_subnet_id`) is also required if this is provided.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_existing_vpc_subnet_name"></a> [existing\_vpc\_subnet\_name](#input\_existing\_vpc\_subnet\_name) | (Optional) Existing subnet name to create Anyscale resources in.<br>If provided, this will skip creating resources with the Anyscale VPC module.<br>VPC ID is also required if this is provided.<br>Default is `null`. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional)<br>A map of default labels to be added to all resources that accept labels.<br>Resource dependent labels will be appended to this list.<br>ex:<pre>labels = {<br>  application = "Anyscale",<br>  environment = "prod"<br>}</pre>Default is an empty map. | `map(string)` | `{}` | no |
| <a name="input_random_char_length"></a> [random\_char\_length](#input\_random\_char\_length) | (Optional)<br>Determines the random suffix length that is used to generate a common name.<br>Certain Google resources have a hard limit on name lengths and this will allow<br>the ability to control how many characters are added as a suffix.<br>Many Google resources have a limit of 28 characters in length.<br>Keep that in mind while setting this value.<br>Must be >= 2 and <= 12.<br>Default is `4` | `number` | `4` | no |
| <a name="input_use_common_name"></a> [use\_common\_name](#input\_use\_common\_name) | (Optional)<br>Determines if a standard name should be used across all resources.<br>If set to true and `common_prefix` is also provided, the `common_prefix` will be used prefixed to a common name.<br>If set to true and `common_prefix` is not provided, the prefix will be `anyscale-`<br>If set to true, this will also use a random suffix to avoid name collisions.<br>Default is `false` | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudstorage_bucket_name"></a> [cloudstorage\_bucket\_name](#output\_cloudstorage\_bucket\_name) | The Google Cloud Storage bucket name. |
| <a name="output_cloudstorage_bucket_selflink"></a> [cloudstorage\_bucket\_selflink](#output\_cloudstorage\_bucket\_selflink) | The Google Cloud Storage self link. |
| <a name="output_cloudstorage_bucket_url"></a> [cloudstorage\_bucket\_url](#output\_cloudstorage\_bucket\_url) | The Google Cloud Storage url for the bucket. Will be in the format `gs://<bucket-name>`. |
| <a name="output_filestore_fileshare_name"></a> [filestore\_fileshare\_name](#output\_filestore\_fileshare\_name) | The Google Filestore fileshare name. |
| <a name="output_filestore_id"></a> [filestore\_id](#output\_filestore\_id) | The Google Filestore id. |
| <a name="output_filestore_location"></a> [filestore\_location](#output\_filestore\_location) | The Google Filestore location. |
| <a name="output_filestore_name"></a> [filestore\_name](#output\_filestore\_name) | The Google Filestore name. |
| <a name="output_iam_anyscale_access_role_email"></a> [iam\_anyscale\_access\_role\_email](#output\_iam\_anyscale\_access\_role\_email) | The Google IAM Anyscale Access Role email. |
| <a name="output_iam_anyscale_access_role_id"></a> [iam\_anyscale\_access\_role\_id](#output\_iam\_anyscale\_access\_role\_id) | The Google IAM Anyscale Access Role id. |
| <a name="output_iam_anyscale_access_role_name"></a> [iam\_anyscale\_access\_role\_name](#output\_iam\_anyscale\_access\_role\_name) | The Google IAM Anyscale Access Role name. |
| <a name="output_iam_anyscale_access_role_unique_id"></a> [iam\_anyscale\_access\_role\_unique\_id](#output\_iam\_anyscale\_access\_role\_unique\_id) | The Google IAM Anyscale Access Role unique id. |
| <a name="output_iam_anyscale_cluster_node_role_email"></a> [iam\_anyscale\_cluster\_node\_role\_email](#output\_iam\_anyscale\_cluster\_node\_role\_email) | The Google IAM Anyscale Cluster Node Role email. |
| <a name="output_iam_anyscale_cluster_node_role_id"></a> [iam\_anyscale\_cluster\_node\_role\_id](#output\_iam\_anyscale\_cluster\_node\_role\_id) | The Google IAM Anyscale Cluster Node Role id. |
| <a name="output_iam_anyscale_cluster_node_role_name"></a> [iam\_anyscale\_cluster\_node\_role\_name](#output\_iam\_anyscale\_cluster\_node\_role\_name) | The Google IAM Anyscale Cluster Node Role name. |
| <a name="output_iam_anyscale_cluster_node_role_unique_id"></a> [iam\_anyscale\_cluster\_node\_role\_unique\_id](#output\_iam\_anyscale\_cluster\_node\_role\_unique\_id) | The Google IAM Anyscale Cluster Node Role unique id. |
| <a name="output_iam_workload_identity_pool_id"></a> [iam\_workload\_identity\_pool\_id](#output\_iam\_workload\_identity\_pool\_id) | The Google IAM Anyscale Workload Identity Pool id. |
| <a name="output_iam_workload_identity_pool_name"></a> [iam\_workload\_identity\_pool\_name](#output\_iam\_workload\_identity\_pool\_name) | The Google IAM Anyscale Workload Identity Pool name. |
| <a name="output_iam_workload_identity_provider_id"></a> [iam\_workload\_identity\_provider\_id](#output\_iam\_workload\_identity\_provider\_id) | The Google IAM Anyscale Workload Identity Provider id. |
| <a name="output_iam_workload_identity_provider_name"></a> [iam\_workload\_identity\_provider\_name](#output\_iam\_workload\_identity\_provider\_name) | The Google IAM Anyscale Workload Identity Provider name. |
| <a name="output_private_subnet_cidr"></a> [private\_subnet\_cidr](#output\_private\_subnet\_cidr) | The Google VPC private subnet cidr. |
| <a name="output_private_subnet_id"></a> [private\_subnet\_id](#output\_private\_subnet\_id) | The Google VPC private subnet id. |
| <a name="output_private_subnet_name"></a> [private\_subnet\_name](#output\_private\_subnet\_name) | The Google VPC private subnet name. |
| <a name="output_private_subnet_region"></a> [private\_subnet\_region](#output\_private\_subnet\_region) | The Google VPC private subnet region. |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The Google Project id. |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | The Google Project name. |
| <a name="output_public_subnet_cidr"></a> [public\_subnet\_cidr](#output\_public\_subnet\_cidr) | The Google VPC public subnet cidr. |
| <a name="output_public_subnet_id"></a> [public\_subnet\_id](#output\_public\_subnet\_id) | The Google VPC public subnet id. |
| <a name="output_public_subnet_name"></a> [public\_subnet\_name](#output\_public\_subnet\_name) | The Google VPC public subnet name. |
| <a name="output_public_subnet_region"></a> [public\_subnet\_region](#output\_public\_subnet\_region) | The Google VPC public subnet region. |
| <a name="output_vpc_firewall_id"></a> [vpc\_firewall\_id](#output\_vpc\_firewall\_id) | The Google VPC firewall policy id. |
| <a name="output_vpc_firewall_policy_name"></a> [vpc\_firewall\_policy\_name](#output\_vpc\_firewall\_policy\_name) | The Google VPC firewall policy name. |
| <a name="output_vpc_firewall_selflink"></a> [vpc\_firewall\_selflink](#output\_vpc\_firewall\_selflink) | The Google VPC firewall policy self link. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The Google VPC id. |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | The Google VPC network name. |
| <a name="output_vpc_selflink"></a> [vpc\_selflink](#output\_vpc\_selflink) | The Google VPC self link. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- References -->
[Terraform]: https://www.terraform.io
[Issues]: https://github.com/anyscale/terraform-google-anyscale-cloudfoundation-modules/issues
[badge-build]: https://github.com/anyscale/terraform-google-anyscale-cloudfoundation-modules/workflows/CI/CD%20Pipeline/badge.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20-623CE4.svg?logo=terraform
[badge-tf-google]: https://img.shields.io/badge/Google-4.+-F8991D.svg?logo=terraform
[build-status]: https://github.com/anyscale/terraform-google-anyscale-cloudfoundation-modules/actions
