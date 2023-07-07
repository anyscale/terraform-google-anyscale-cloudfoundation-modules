# anyscale-v2-kitchensink example

Builds the resources for Anyscale in a Google Cloud.
This example will build resources with as many variables as possible.
Creates a v2 stack including:
- Project
- Enabling Cloud APIs on the Project
- Cloud Storage Bucket - Standard
- IAM Roles
- VPC with publicly routed subnets (no internal)
- VPC Firewall
- FileStore

Since this creates a new project, the user/role that is executing this example needs to have the `roles/billing.user` permission to tie the project to a Billing Account.

WIP

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->   |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
