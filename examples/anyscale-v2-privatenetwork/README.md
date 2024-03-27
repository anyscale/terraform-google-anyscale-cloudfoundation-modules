# anyscale-v2-privatenetwork example

Builds the resources for Anyscale in a Google Cloud.
This will build a private subnet (no public) and NAT GW.
This will also build all the resources with the same name.
Creates a v2 stack including:
- Project
- Enabling Cloud APIs on the Project
- Cloud Storage Bucket - Standard
- IAM Roles
- VPC with publicly routed subnets (no internal)
- VPC Firewall
- FileStore
- Memorystore

This requires either a jumpbox in the environment, a VPN into the GCE environment, or some alternative
method to route traffic from end user computers to the clusters that Anyscale creates. Testing was done
via a jumpbox.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
| <a name="module_google_anyscale_v2_privatenetwork"></a> [google\_anyscale\_v2\_privatenetwork](#module\_google\_anyscale\_v2\_privatenetwork) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID. Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_deploy_env"></a> [anyscale\_deploy\_env](#input\_anyscale\_deploy\_env) | (Required) Anyscale deploy environment. Used in resource names and tags. | `string` | n/a | yes |
| <a name="input_anyscale_google_region"></a> [anyscale\_google\_region](#input\_anyscale\_google\_region) | (Required) Google region to deploy Anyscale resources. | `string` | n/a | yes |
| <a name="input_anyscale_google_zone"></a> [anyscale\_google\_zone](#input\_anyscale\_google\_zone) | (Required) Google zone to deploy Anyscale resources. | `string` | n/a | yes |
| <a name="input_anyscale_org_id"></a> [anyscale\_org\_id](#input\_anyscale\_org\_id) | (Required) Anyscale Organization ID | `string` | n/a | yes |
| <a name="input_billing_account_id"></a> [billing\_account\_id](#input\_billing\_account\_id) | (Required) Google billing account ID to deploy Anyscale resources. | `string` | n/a | yes |
| <a name="input_customer_ingress_cidr_ranges"></a> [customer\_ingress\_cidr\_ranges](#input\_customer\_ingress\_cidr\_ranges) | The IPv4 CIDR blocks that allows access Anyscale clusters.<br>These are added to the firewall and allows port 443 (https) and 22 (ssh) access.<br>ex: `52.1.1.23/32,10.1.0.0/16'<br>` | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) A map of labels to all resources that accept labels. | `map(string)` | <pre>{<br>  "environment": "test",<br>  "test": true<br>}</pre> | no |
| <a name="input_root_project_id"></a> [root\_project\_id](#input\_root\_project\_id) | (Required) Google project ID to deploy Anyscale resources. Will create a new sub-project by default. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_registration_command"></a> [registration\_command](#output\_registration\_command) | The Anyscale registration command. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
