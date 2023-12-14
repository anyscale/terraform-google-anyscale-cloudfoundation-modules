# anyscale-v2-existingidentityfederation example

Builds the resources for Anyscale in a Google Cloud.
This will also build all the resources with the same name.
Creates a v2 stack including:
- Enabling Cloud APIs on the Project
- Cloud Storage Bucket - Standard
- IAM Roles
  - Uses an existing Workload Identity Federation Pool and Provider - in an existing project
- VPC with publicly routed subnets (no internal)
- VPC Firewall
- FileStore


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_google_anyscale_v2_existingidentityfederation"></a> [google\_anyscale\_v2\_existingidentityfederation](#module\_google\_anyscale\_v2\_existingidentityfederation) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyscale_cloud_id"></a> [anyscale\_cloud\_id](#input\_anyscale\_cloud\_id) | (Optional) Anyscale Cloud ID. Default is `null`. | `string` | `null` | no |
| <a name="input_anyscale_deploy_env"></a> [anyscale\_deploy\_env](#input\_anyscale\_deploy\_env) | (Required) Anyscale deploy environment. Used in resource names and tags. | `string` | `"production"` | no |
| <a name="input_anyscale_google_region"></a> [anyscale\_google\_region](#input\_anyscale\_google\_region) | (Required) Google region to deploy Anyscale resources. | `string` | n/a | yes |
| <a name="input_anyscale_google_zone"></a> [anyscale\_google\_zone](#input\_anyscale\_google\_zone) | (Required) Google zone to deploy Anyscale resources. | `string` | n/a | yes |
| <a name="input_anyscale_org_id"></a> [anyscale\_org\_id](#input\_anyscale\_org\_id) | (Required) Anyscale Organization ID | `string` | n/a | yes |
| <a name="input_customer_ingress_cidr_ranges"></a> [customer\_ingress\_cidr\_ranges](#input\_customer\_ingress\_cidr\_ranges) | The IPv4 CIDR blocks that allows access Anyscale clusters.<br>These are added to the firewall and allows port 443 (https) and 22 (ssh) access.<br>ex: `52.1.1.23/32,10.1.0.0/16'<br>` | `string` | n/a | yes |
| <a name="input_existing_project_id"></a> [existing\_project\_id](#input\_existing\_project\_id) | (Required) Google project ID to deploy Anyscale resources. | `string` | n/a | yes |
| <a name="input_existing_workload_identity_provider_name"></a> [existing\_workload\_identity\_provider\_name](#input\_existing\_workload\_identity\_provider\_name) | (Optional) Existing Workload Identity Provider Name.<br><br>The name of an existing Workload Identity Provider that you'd like to use. This can be in a different project.<br><br>You can retrieve the name of an existing Workload Identity Provider by running the following command:<pre>gcloud iam workload-identity-pools providers list --location global --workload-identity-pool anyscale-access-pool</pre>ex:<pre>existing_workload_identity_provider = "projects/1234567890/locations/global/workloadIdentityPools/anyscale-access-pool/providers/anyscale-access-provider"</pre> | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | (Optional) A map of labels to all resources that accept labels. | `map(string)` | <pre>{<br>  "environment": "test",<br>  "test": true<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_registration_command"></a> [registration\_command](#output\_registration\_command) | The Anyscale registration command. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
