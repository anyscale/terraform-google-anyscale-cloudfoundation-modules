# A Beginner's Guide to Using Terraform with Google Cloud Provider and Anyscale Google Cloudfoundation Module

## Introduction
In this guide, we will walk through setting up and using Terraform with the Google Cloud Provider from your local laptop. We will be using the Anyscale Google Cloudfoundation module found in the Terraform Registry. We will create a basic example based on the anyscale-v2-commonname example from the registry.

The anyscale-v2-commonname example builds the following Google Cloud resources:
- Project
- Enabling Cloud APIs on the Project
- Cloud Storage Bucket - Standard
- IAM Roles
- VPC with publicly routed subnets (no internal)
- VPC Firewall
- FileStore

## Prerequisites
1. A Google Cloud account with billing enabled
2. Terraform installed on your local laptop (version 1.0.0 or later)
   1. You can install terraform on a mac with `brew` via `brew install terraform`. Other [install options](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/install-cli) are available.
3. Google Cloud SDK (gcloud) installed on your local laptop
   1. You can install gcloud with `brew` via `brew install gcloud`. Other [install options](https://cloud.google.com/sdk/docs/install) are available.
4. Git CLI installed on your local laptop.
5. Anyscale CLI installed on your local laptop needs to be 0.5.104 or newer. You can install/upgrade your cli with: `pip install anyscale --upgrade`
6. Basic understanding of Terraform and Infrastructure as Code

#### Required Gcloud user permissions
To successfully run the Terraform commands in this guide, your Google Cloud user must have appropriate permissions. The user should have the following roles:
1. **Project owner**: The user should be the project owner or have a custom role with equivalent permissions. This role allows the user to create and manage resources in the Google Cloud project.
2. **Compute Instance Admin**: This role allows the user to create and manage Compute Engine instances.
3. **Service Account User**: This role enables the user to run operations as the service account.
4. **Compute Network Admin**: This role is required for managing networking resources such as VPCs, subnets, and firewall rules.
5. **Billing Account User**: This role is required for the common name example as it creates a new project - when a project is created, you must be able to tie the project to a Google Billing Account ID. This particular permission is only required if you are using the common name example.

**Note**: If you're using a Service Account to run the Terraform commands, make sure it has the required permissions mentioned above. You can follow the same steps to assign roles to the Service Account.

## Steps

### 1. Authenticate with Google Cloud:
Before using the Google Cloud provider with Terraform, you need to authenticate. Run the following command to authenticate with your Google Cloud account:
```
gcloud auth application-default login
```

### 2. Clone the Anyscale examples repository:
Clone the Anyscale examples repository to your local laptop to access the example configuration files:
```
git clone https://github.com/anyscale/terraform-google-anyscale-cloudfoundation-modules
```

### 3. Navigate to the example directory:
Navigate to the example directory (anyscale-v2-commonname) within the cloned repository:
```
cd terraform-google-anyscale-cloudfoundation-modules/examples/anyscale-v2-commonname
```

### 4. Initialize Terraform:
Before running Terraform commands, you need to initialize the working directory. Run the following command to initialize Terraform with the Google provider:
```
terraform init
```

### 5. Modify the `main.tf` file:
In the `main.tf` file, modify the configuration to fit your needs. You may need to update the variables for you're needs. Some common variables to update are listed below. Additionally, customize the resources created by the Anyscale module. An example of this is to change the `anyscale_filestore_tier` from STANDARD to ENTERPRISE. You can also update
the region that resources are created in. In the examples, resources are created in US regions, but these regions and AZ's can be changed.

#### Variables to modify
- `anyscale_vpc_public_subnet_cidr` - This is the Public Subnet CIDR range you wish to create.
- `customer_ingress_cidr_ranges` - This is the CIDR range to lock down public access from. It can be 0.0.0.0/0 - it can also be locked down to the CIDR range you're users will be using to access clusters.
- `anyscale_org_id` - This is the Anyscale Organization ID. It can be found in the Anyscale UI by an Organization Owner by clicking on the Organization menu option under their User Name.


### 6. Create a `terraform.tfvars` file:
Create a `terraform.tfvars` file in the example directory to store your project-specific variables. Update the variables according to your Google Cloud setup. For example:
```
anyscale_org_id        = "<your-anyscale_org_id>"
anyscale_google_region = "us-central1"
anyscale_google_zone   = "us-central1-a"

billing_account_id     = "<your_billing_account_id>"
root_folder_number     = "<your_gcloud_folder_number>"

customer_ingress_cidr_ranges = "0.0.0.0/0"
```

- `root_folder_number` - This is the Google Project Folder number to create the resources in.
- `billing_account_id` - This is the Google Billing Account ID
- `anyscale_google_region` - This is the Google Region to use.
- `anyscale_google_zone` - This is the Google Zone to use within the region. This only applies if you create a STANDARD file store.
- `anyscale_org_id` - This is the Anyscale Organization ID. This can be found by an Anyscale Organization Owner by clicking on their name in the Anyscale Console, and then clicking on `Organization`.

### 7. Validate the configuration:
Before creating resources, you can validate your configuration using the following command:
```
terraform validate
```

### 8. Plan the changes:
Check the planned changes to your infrastructure by running:
```
terraform plan -var-file="terraform.tfvars"
```

### 9. Apply the changes:
If everything looks good, apply the changes to create the resources:
```
terraform apply -var-file="terraform.tfvars"
```
Type 'yes' when prompted to confirm the resource creation.

### 10. Verify the created resources:
Check your Google Cloud Console to verify that the resources have been created successfully.

### 11. Use the outputs to register Anyscale Cloud:
With the outputs from Terraform, you can use the `anyscale cloud register`
command example to register an Anyscale Cloud. You will want to make
sure to edit the name of the cloud.

Example Cloud Register command for GCP:
```
anyscale cloud register --provider gcp  \
--name gce-anyscale-tf-test-1 \
--vpc-name anyscale-tf-test-1 \
--subnet-names anyscale-tf-test-1-subnet-uscentral1 \
--filestore-instance-id anyscale-tf-test-1  \
--filestore-location us-central1-a \
--anyscale-service-account-email anyscale-tf-test-1-crossacc@gcp-register-cloud-1.iam.gserviceaccount.com \
--instance-service-account-email anyscale-tf-test-1-cluster@gcp-register-cloud-1.iam.gserviceaccount.com \
--firewall-policy-names anyscale-tf-test-1-fw  \
--cloud-storage-bucket-name anyscale-tf-test-1 \
--region us-central1 \
--project-id gcp-register-cloud-dogfood-1 \
--provider-id projects/123456789012/locations/global/workloadIdentityPools/anyscale-tf-test-1/providers/private-cloud
```


### 12. Clean up resources (optional):
Once you are done, you can destroy the resources created by Terraform:
```
terraform destroy -var-file="terraform.tfvars"
```
Type 'yes' when prompted to confirm the resource destruction.

## Conclusion
In this guide, we have covered how to set up and use Terraform with the Google Cloud Provider from a local laptop. We used the Anyscale Google Cloudfoundation module to create resources based on the Anyscale-v2-commonname example. Now you can create and manage your infrastructure on Google Cloud using Terraform and the Anyscale module.
