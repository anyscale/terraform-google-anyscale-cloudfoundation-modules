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
