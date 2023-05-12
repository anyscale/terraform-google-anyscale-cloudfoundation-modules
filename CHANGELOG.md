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
