# anyscale-v2-vpc-shared example

Builds the resources for Anyscale in a Google Cloud.
This will build all resources in an existing project.
It will use a Shared VPC from a different project to (optionally) create Firewall resources.
It will use an existing Project (with which the VPC has been shared with)
This will also build all the resources with the same name.

Creates a stack including:
- Enabling Cloud APIs on the Project
- Cloud Storage Bucket - Standard
- IAM Roles
- VPC Firewall
- FileStore (Requires private service access to be enabled on the shared VPC. See the [Google Documentation](https://cloud.google.com/filestore/docs/shared-vpc#enable_private_service_access_on_the_network) for more information)

Requirements:
- Source GCP Project
  - VPC created
  - Service Networking API enabled
  - VPC shared with Second Project
  - VPC Private Service Connection configured (following above Google Documentation)
    - Allocated IP ranges configured
    - Private Connections to Services enabled
- A second Anyscale GCP Project
  - Service Netowrking API enabled
  - The VPC created in the first GCP project should be shared with this Project

Once the Anyscale Access Service Account has been created, additionally, the service account needs to be granted "Compute Network User" on the Source GCP Project.

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
| <a name="module_google_anyscale_v2_vpc_shared"></a> [google\_anyscale\_v2\_vpc\_shared](#module\_google\_anyscale\_v2\_vpc\_shared) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_google_region"></a> [anyscale\_google\_region](#input\_anyscale\_google\_region) | (Required) Google region to deploy Anyscale resources. | `string` | n/a | yes |
| <a name="input_anyscale_google_zone"></a> [anyscale\_google\_zone](#input\_anyscale\_google\_zone) | (Required) Google zone to deploy Anyscale resources. | `string` | n/a | yes |
| <a name="input_anyscale_org_id"></a> [anyscale\_org\_id](#input\_anyscale\_org\_id) | (Required) Anyscale Organization ID | `string` | n/a | yes |
| <a name="input_customer_ingress_cidr_ranges"></a> [customer\_ingress\_cidr\_ranges](#input\_customer\_ingress\_cidr\_ranges) | The IPv4 CIDR blocks that allows access Anyscale clusters.<br/>These are added to the firewall and allows port 443 (https) and 22 (ssh) access.<br/>ex: `52.1.1.23/32,10.1.0.0/16'<br/>` | `string` | n/a | yes |
| <a name="input_existing_project_id"></a> [existing\_project\_id](#input\_existing\_project\_id) | (Required) Google project ID to deploy Anyscale resources.<br/><br/>ex:<pre>existing_project_id = "anyscale-project"</pre> | `string` | n/a | yes |
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID. Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_deploy_env"></a> [anyscale\_deploy\_env](#input\_anyscale\_deploy\_env) | (Optional) Anyscale deploy environment. Used in resource names and tags. | `string` | `"production"` | no |
| <a name="input_enable_anyscale_vpc_firewall"></a> [enable\_anyscale\_vpc\_firewall](#input\_enable\_anyscale\_vpc\_firewall) | (Optional) Determines if the Anyscale VPC Firewall is created.<br/><br/>ex:<pre>enable_anyscale_vpc_firewall = true</pre> | `bool` | `true` | no |
| <a name="input_existing_vpc_name"></a> [existing\_vpc\_name](#input\_existing\_vpc\_name) | (Required) An existing VPC Name.<br/><br/>If provided, this module will skip creating a new VPC with the Anyscale VPC module.<br/>An existing VPC Subnet Name (`existing_vpc_subnet_name`) is also required if this is provided.<br/><br/>ex:<pre>existing_vpc_name = "anyscale-vpc"</pre> | `string` | `null` | no |
| <a name="input_existing_vpc_subnet_name"></a> [existing\_vpc\_subnet\_name](#input\_existing\_vpc\_subnet\_name) | (Required) Existing subnet name to create Anyscale resources in.<br/><br/>If provided, this will skip creating resources with the Anyscale VPC module.<br/>An existing VPC Name (`existing_vpc_name`) is also required if this is provided.<br/><br/>ex:<pre>existing_vpc_subnet_name = "anyscale-subnet"</pre> | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) A map of labels to all resources that accept labels. | `map(string)` | <pre>{<br/>  "environment": "test",<br/>  "test": true<br/>}</pre> | no |
| <a name="input_shared_vpc_project_id"></a> [shared\_vpc\_project\_id](#input\_shared\_vpc\_project\_id) | (Required) Google project ID for the Shared VPC.<br/><br/>If provided, the firewall resources will be created in the Shared VPC Project.<br/><br/>An existing VPC Name (`existing_vpc_name`) and existing Subnet Name (`existing_vpc_subnet_name`) are also required when this is provided.<br/><br/>ex:<pre>shared_vpc_project_id = "anyscale-vpc"</pre> | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_registration_command"></a> [registration\_command](#output\_registration\_command) | The Anyscale registration command. |
<!-- END_TF_DOCS -->
