package test

import (
	"testing"

	// "github.com/gruntwork-io/terratest/modules/gcp"
	"github.com/gruntwork-io/terratest/modules/environment"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestAnyscaleResources(t *testing.T) {
	t.Parallel()

	// Create all resources in the following zone
	googleRegion := "us-central1"
	billing_account_id := getGoogleBillingIDFromEnvVar(t)
	folder_id := getGoogleFolderIDFromEnvVar(t)

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "../examples",
		Vars: map[string]interface{}{
			"google_region":       googleRegion,
			"billing_account_id":  billing_account_id,
			"folder_id":           folder_id,
			"anyscale_cloud_id":   "cld_automated_terraform_test",
			"anyscale_deploy_env": "test",
		},
		Upgrade: true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable. If it's not available, fail the test.
	allDefaultsAnyscaleIdOutput := terraform.OutputRequired(t, terraformOptions, "all_defaults_id")
	assert.Contains(t, allDefaultsAnyscaleIdOutput, "anyscale-project-")

	allDefaultsAnyscaleNumberOutput := terraform.OutputRequired(t, terraformOptions, "all_defaults_number")
	assert.NotEmpty(t, allDefaultsAnyscaleNumberOutput)

	allDefaultsAnyscaleProjectName := terraform.OutputRequired(t, terraformOptions, "all_defaults_name")
	assert.Equal(t, allDefaultsAnyscaleProjectName, "anyscale-project")

	// Kitchen Sink Cluster Node Custom Policy
	kitchenSyncIdOutput := terraform.OutputRequired(t, terraformOptions, "kitchen_sink_id")
	assert.Contains(t, kitchenSyncIdOutput, "anyscale-tf-ks-proj-")

	kitchenSyncNameOutput := terraform.OutputRequired(t, terraformOptions, "kitchen_sink_name")
	assert.Equal(t, kitchenSyncNameOutput, "anyscale-tf-ks-name")

	kitchenSyncProjectNumber := terraform.OutputRequired(t, terraformOptions, "kitchen_sink_region")
	assert.NotEmpty(t, kitchenSyncProjectNumber)

}

func getGoogleBillingIDFromEnvVar(t *testing.T) string {
	return environment.GetFirstNonEmptyEnvVarOrEmptyString(t, billingEnvVars)
}

func getGoogleFolderIDFromEnvVar(t *testing.T) string {
	return environment.GetFirstNonEmptyEnvVarOrEmptyString(t, folderEnvVars)
}

var billingEnvVars = []string{
	"GOOGLE_BILLING_ACCOUNT",
	"GOOGLE_BILLING_ACCOUNT_ID",
}

var folderEnvVars = []string{
	"GOOGLE_FOLDER_ID",
	"FOLDER_ID",
}
