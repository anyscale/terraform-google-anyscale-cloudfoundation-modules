## 0.16.3 (Released)
FEATURES:

BUG FIXES:
- Add missing Filestore Tier types: Regional, Zonal

BREAKING CHANGES:

OTHER:

## 0.16.2 (Released)
FEATURES:

BUG FIXES:
- Fix IAM SA Description when passing in a Cloud ID
  - When passing in an Cloud ID, the IAM SA description was trying to add var.google_region however this variable was always null. This caused the IAM SA to fail to create.

BREAKING CHANGES:

OTHER:
- Uupdates to pre-commit-config.yaml to update to the latest hook versions.

## 0.16.1 (Released)
FEATURES:

BUG FIXES:
- E2E test - Additional sleeps for cloud resource deletion

BREAKING CHANGES:

OTHER:

## 0.16.0 (Released)
FEATURES:
- Update CloudStorage from binding to member for IAM policies.

BUG FIXES:
- Fix firewall Port Assignments were not correctly getting pulled in.

BREAKING CHANGES:

OTHER:

## 0.15.3 (Released)
FEATURES:

BUG FIXES:
- Fix Firewall Rule Names
  - The firewall rule names were not properly getting pulled from the variable when pulling from the predefined_firewall_rules.

BREAKING CHANGES:

OTHER:

## 0.15.2 (Released)
FEATURES:

BUG FIXES:
- Provide additional outputs and roles for K8s deployments
  - The new Anyscale K8s Operator has additional permission requirements which have been added to this.
  - Additional changes to support memberoutputs for IAM Service Accounts.

BREAKING CHANGES:

OTHER:

## 0.15.1 (Released)
FEATURES:

BUG FIXES:
- Add additional ports for Anyscale Machine Pools.
  - Additional ports opened up for AMP in the `google-anyscale-vpc-firewall` module. The initial ports were only for AMP and did not include Ray specific ports.

BREAKING CHANGES:

OTHER:

## 0.15.0 (Released)
FEATURES:
- add: Optional VPC Firewall ingress rule for Anyscale Machine Pools
  - Anyscale Machine Pools requires a specific set of ports to be open from the AMP Node into (ingress) the head node running in the cloud. This update includes an optional parameter ingress_from_machine_pool_cidr_ranges which, when provided, will create a new Firewall Rule allowing the appropriate ports for Anyscale Machine Pools.

BUG FIXES:

BREAKING CHANGES:

OTHER:

## 0.14.4 (Released)
FEATURES:

BUG FIXES:
- VPC Firewall ingress for GCP Health Check
  - The GCP Health Check only needs to be valid for port 8000. The previous fix removed that limitation and opened up all TCP ports.

BREAKING CHANGES:

OTHER:

## 0.14.3 (Released)
FEATURES:

BUG FIXES:
- VPC Firewall when using CIDR Ingress Range

BREAKING CHANGES:

OTHER:

## 0.14.2 (Released)
FEATURES:

BUG FIXES:
- VPC Firewall for Proxy-Only Subnet and Subnet Firewall Rule
  - When the VPC Proxy Subnet was not in the same CIDR range as the rest of the VPC, the firewall rule was not being correctly configured for the proxy subnet. This change fixes the firewall rule to allow traffic from the proxy subnet to the rest of the VPC and provides a test in the `examples/anyscale-v2-privatenetwork` folder.


BREAKING CHANGES:

OTHER:

## 0.14.1 (Released)
FEATURES:

BUG FIXES:
- iam: add storage.objects.list to control plane role
  - The Workspace dependencies tab requires storage.objects.list permissions.

BREAKING CHANGES:

OTHER:

## 0.14.0 (Released)
FEATURES:
- IAM change *_iam_binding to *_iam_members
  - The current use of *_iam_binding resources is authoritative. It doesn't allow users to add or update members. Changed to use *_iam_members which is non-authoritative. This will be more flexbible and easier to integrate for our users.

BUG FIXES:

BREAKING CHANGES:

OTHER:

## 0.13.1 (Released)
FEATURES:

BUG FIXES:
- Update to VPC NAT Configuration if using Private Networking. GCP Dynamic Port Allocation causes problems with advanced Anyscale Network cluster startup processes. Disabling Dynamic Port Allocation and manually setting min/max ports per VM solves this. Added two new variables to the google-anyscale-vpc sub-module to support this configuration. Changed the minimum ports per VM to 32 from 64.

BREAKING CHANGES:

OTHER:

## 0.13.0 (Released)
FEATURES:
- Optional new sub-module to manage the `_Default` Logging Sink - `syslog` logs are automatically enabled for new Projects and this can lead to unexpected storage costs in Projects with many active Anyscale clusters and nodes.

BUG FIXES:

BREAKING CHANGES:

OTHER:
- tflint updates
- pre-commit updates
- trivy rule update on cloudstorage module

## 0.12.1 (Released)
FEATURES:

BUG FIXES:
- IAM Role fix to support new Anyscale Logging feature.

BREAKING CHANGES:

OTHER:

## 0.12.0 (Released)
FEATURES:
- Update to GCP Terraform Provider v5

BUG FIXES:
- VPC Submodule
  - Proxy Subnet fix for change to GCP APIs related to IPv6
    - GCP released a change and with v5 of the GCP Terraform Provider, the IPv6 parameter for Proxy Only Subnets is not suported/required.
  - Subnet Names are now managed by the root module
    - The previous behavior was causing the replacement of Subnets on any parameter change to the root module.
- VPC Firewall Submodule
  - Update to use VPC ID for attachment instead of dynamically identifying from the name.
    - The previous behavior was causing the replacement of the VPC Firewall on any parameter change to the root module.

BREAKING CHANGES:

OTHER:
- Change from tfsec to trivy for pre-commit
- TFLint updated for GCP Ruleset
- General updates/fixes for all tests in submodule examples for VPC Firewall and CloudStorage
- pre-commit updates to the latest revisions

## 0.11.0 (Released)
FEATURES:
- Bucket CORS Rules updates to support additional Anyscale UI functionality

BUG FIXES:

BREAKING CHANGES:

OTHER:
- Documentation updates

## 0.10.0 (Released)
FEATURES:
- Support for shared VPC
  - Example `anyscale-v2-vpc-shared` created to demonstrate this. Please make sure to read the README in the example for additional requirements.
  - Requires Anyscale CLI v0.5.163 or greater.
  - Supports creating a Firewall in the Shared VPC Project if an existing firewall is not provided
- Update VPC Firewall to allow GCP Load Balancer Health Check CIDR ranges.
  - This rule is required for Anyscale Services
- Minimal IAM Service Account Roles
  - Project/Owner or Project/Editor are no longer required for the Anyscale Service Account.

BUG FIXES:

BREAKING CHANGES:
- Updates to output names for Service Accounts.
- Changes to IAM Service Account Terraform names
  - This will replace existing IAM Service Accounts if upgrading.
  - You will need to create new Anyscale Clouds.

OTHER:
- TFLint Rules Update
- Cleanup of unused variables
- pre-commit update

## 0.9.0 (Released)
FEATURES:
- Support for existing Workload Identify Federation pool and provider
  - This allows for following of [Google's best practice](https://cloud.google.com/iam/docs/best-practices-for-using-workload-identity-federation#dedicated-project) of creating all WIF/WIP in a dedicated project.
  - In this situation, the IAM submodule will NOT create a Workload Identity Federation Pool or Provider
  - Additional example for Existing Identity Federation built and tested in /examples/anyscale-v2-existingidentityfederation
  - If using this, please follow the Anyscale Documentation for [GCP Workload Identity Federation](https://docs.anyscale.com/cloud-deployment/gcp/manage-clouds#workload-identity-federation)

BUG FIXES:

BREAKING CHANGES:

OTHER:
- Updates to End to End testing python script

## 0.8.2 (Released)
FEATURES:

BUG FIXES:
- Improved support for Anyscale Services on Private VPCs
  - We've added an additional VPC proxy subnet to support load balancers on GCP when utilizing private VPCs.
  - To utilize this feature, we've included a new root module optional variable: `anyscale_vpc_proxy_subnet_cidr`
  - See the example in `/examples/anyscale-v2-privatenetwork`

BREAKING CHANGES:

OTHER:
- General doc updates and cleanup
- Root module variables cleanup with better descriptions and examples
- tflint and changelog updates
- Initial pass at End to End testing integration


## 0.8.1 (Released)
FEATURES:

BUG FIXES:
- Fix to the `google-anyscale-iam` submodule when `anyscale_cloud_id` is provided
  - When `anyscale_cloud_id` is provided, the IAM submodule should update descriptions of the roles/resources created, however the way it was working was looking for a variable that was always null and thus causing a terraform error. This has been replaced with a try to see if the additional variable is populated.

BREAKING CHANGES:

OTHER:


## 0.8.0 (Released)
FEATURES:
- New integration for Anyscale Service Head Node fault tolerance.
  - New optional submodule: `google-anyscale-memorystore`
    - This sub-module can be used to create a Memorystore Redis instance which is then used with Anyscale Services to enable head node fault tolerance.
  - Updates to `google-anyscale-cloudapis` to optionally enable memorystore api (redis.googleapis.com)
  - To see how this module can be enabled and used, please look in the `examples/anyscale-v2-kitchensink` or the `anyscale-v2-privatenetwork` folders
- New logging integration via [Vector](https://vector.dev/) with GCP Logging and Cloud Monitoring.
  - Updates to `google-anyscale-iam` to optionally grant access to GCP Logging and Cloud Monitoring
  - Updates to `google-anyscale-cloudapis` to optionally enable GCP Logging (logging.googleapis.com) and Cloud Monitoring (monitoring.googleapis.com)

BUG FIXES:

BREAKING CHANGES:

OTHER:
- General doc updates and cleanup
- Root module variables cleanup with better descriptions and examples
- tflint and changelog updates
- Initial pass at End to End testing integration

## 0.7.1 (Released)
FEATURES:

BUG FIXES:

BREAKING CHANGES:

OTHER:
- Doc updates, pre-commit update

## 0.7.0 (Released)
FEATURES:

BUG FIXES:

BREAKING CHANGES:

OTHER:
- Changed defaults for File Store tier and size to match `anyscale cloud setup` defaults of STANDARD and 1TB.

## 0.6.1 (Released)
FEATURES:

BUG FIXES:

BREAKING CHANGES:

OTHER:
- End to end unit tests for root module

## 0.6.0 (Released)
FEATURES:
- Change the default filestore capacity size.

BUG FIXES:

BREAKING CHANGES:

OTHER:

## 0.5.0 (Released)
FEATURES:
- CloudAPIs submodule - add additional APIs to match the APIs enabled by `anyscale cloud setup`:
  - cloudresourcemanager.googleapis.com
  - serviceusage.googleapis.com
  - deploymentmanager.googleapis.com

BUG FIXES:

BREAKING CHANGES:

OTHER:

## 0.4.0 (Released)
FEATURES:
- Add certificate manager API to the list of APIs to enable. This is to support Anyscale Services v2.

BUG FIXES:

BREAKING CHANGES:

OTHER:

## 0.3.0 (Released)

FEATURES:

BUG FIXES:
- Removed STS API from the list of APIs to enable as it's not required for Anyscale to work.

BREAKING CHANGES:

OTHER:

## 0.2.3 (Released)

FEATURES:

BUG FIXES:

BREAKING CHANGES:

OTHER:
- Examples updated to change var `anyscale_deploy_env` to have a default of `production`
- Examples updated to call out the ability to override the bucket location via `anyscale_bucket_location`
- Getting-started cleanup and fixed broken links

## 0.2.2 (Released)

FEATURES:
- Add getting started documentation

BUG FIXES:

BREAKING CHANGES:

## 0.2.1 (Released)

FEATURES:

BUG FIXES:
- Change project permission from binding to member

BREAKING CHANGES:

## 0.2.0 (Released)

FEATURES:
- Add condition to IAM Workload Identity Provider Pool to lock down the cross account access.

BUG FIXES:
- Fix destroy dependencies between VPC and VPC Firewall
- Update outputs in examples to support Anyscale CLI 0.5.102 which had a param name change

BREAKING CHANGES:
- There is a new required variable: anyscale_organization_id
  This variable is used for the condition for the Provider Pool


## 0.1.0 (Released)

Initial commit

FEATURES:
- Google APIs Submodule
- CloudStorage Submodule
- FileStore Submodule
- IAM Submodule
- Google Project Submodule
- VPC Submodule
- VPC Firewall Submodule
