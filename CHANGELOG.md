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
