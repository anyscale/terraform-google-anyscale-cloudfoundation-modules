# anyscale-v2-vpc-existing example

Builds the resources for Anyscale in a Google Cloud.
This will build all resources in an existing project using an existing VPC and subnet.
This example expects that the VPC, subnet, and firewall policy already exist and meet [Anyscale Requirements](https://docs.anyscale.com/administration/cloud-deployment/deploy-gcp-cloud#3-choose-an-anyscale-cloud-deployment-method).

The example creates a v2 stack including:
- Enabling Cloud APIs on the Project
- Cloud Storage Bucket - Standard
- IAM Roles
- FileStore (with PRIVATE_SERVICE_ACCESS network connect mode)

Requirements:
- An existing Google Cloud Project
- An existing VPC network
- An existing subnet within that VPC
- An existing firewall policy that meets Anyscale requirements
- The VPC must have Private Service Access enabled for FileStore connectivity

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_google_anyscale_v2_vpc_existing"></a> [google\_anyscale\_v2\_vpc\_existing](#module\_google\_anyscale\_v2\_vpc\_existing) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_google_region"></a> [anyscale\_google\_region](#input\_anyscale\_google\_region) | (Required) Google region to deploy Anyscale resources. | `string` | n/a | yes |
| <a name="input_anyscale_google_zone"></a> [anyscale\_google\_zone](#input\_anyscale\_google\_zone) | (Required) Google zone to deploy Anyscale resources. | `string` | n/a | yes |
| <a name="input_anyscale_org_id"></a> [anyscale\_org\_id](#input\_anyscale\_org\_id) | (Required) Anyscale Organization ID | `string` | n/a | yes |
| <a name="input_existing_firewall_policy_name"></a> [existing\_firewall\_policy\_name](#input\_existing\_firewall\_policy\_name) | (Required) An existing firewall policy name.<br/><br/>If provided, this will be used in the cloud registration output.<br/>This example expects an existing VPC and Firewall meeting [Anyscale Requirements](https://docs.anyscale.com/administration/cloud-deployment/deploy-gcp-cloud#3-choose-an-anyscale-cloud-deployment-method).<br/><br/>ex:<pre>existing_firewall_policy_name = "anyscale-firewall-policy"</pre> | `string` | n/a | yes |
| <a name="input_existing_project_id"></a> [existing\_project\_id](#input\_existing\_project\_id) | (Required) Google project ID to deploy Anyscale resources.<br/><br/>ex:<pre>existing_project_id = "anyscale-project"</pre> | `string` | n/a | yes |
| <a name="input_existing_vpc_name"></a> [existing\_vpc\_name](#input\_existing\_vpc\_name) | (Required) An existing VPC Name.<br/><br/>If provided, this module will skip creating a new VPC with the Anyscale VPC module.<br/>An existing VPC Subnet Name (`existing_vpc_subnet_name`) is also required if this is provided.<br/><br/>ex:<pre>existing_vpc_name = "anyscale-vpc"</pre> | `string` | n/a | yes |
| <a name="input_existing_vpc_subnet_name"></a> [existing\_vpc\_subnet\_name](#input\_existing\_vpc\_subnet\_name) | (Required) Existing subnet name to create Anyscale resources in.<br/><br/>If provided, this will skip creating resources with the Anyscale VPC module.<br/>An existing VPC Name (`existing_vpc_name`) is also required if this is provided.<br/><br/>ex:<pre>existing_vpc_subnet_name = "anyscale-subnet"</pre> | `string` | n/a | yes |
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID. Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_deploy_env"></a> [anyscale\_deploy\_env](#input\_anyscale\_deploy\_env) | (Required) Anyscale deploy environment. Used in resource names and tags. | `string` | `"production"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) A map of labels to all resources that accept labels. | `map(string)` | <pre>{<br/>  "environment": "test",<br/>  "test": true<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_registration_command"></a> [registration\_command](#output\_registration\_command) | The Anyscale registration command. |
<!-- END_TF_DOCS -->
