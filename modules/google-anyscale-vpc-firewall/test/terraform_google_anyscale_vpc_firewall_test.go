package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/environment"
	"github.com/gruntwork-io/terratest/modules/gcp"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestAnyscaleResources(t *testing.T) {
	t.Parallel()

	// Create all resources in the following zone
	googleRegion := "us-central1"
	project_id := getGoogleProjectIDFromEnvVar(t)

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "../examples",
		Vars: map[string]interface{}{
			"google_region":       googleRegion,
			"google_project_id":   project_id,
			"anyscale_cloud_id":   "cld_automated_terraform_test",
			"anyscale_deploy_env": "test",
		},
		Upgrade: true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// All Defaults Test
	allDefaultsAnyscaleNameOutput := terraform.OutputRequired(t, terraformOptions, "all_defaults_bucketname")
	assert.Contains(t, allDefaultsAnyscaleNameOutput, "anyscale-")
	gcp.AssertStorageBucketExists(t, allDefaultsAnyscaleNameOutput)

	allDefaultsAnyscaleSelfLinkOutput := terraform.OutputRequired(t, terraformOptions, "all_defaults_selflink")
	assert.NotEmpty(t, allDefaultsAnyscaleSelfLinkOutput)

	allDefaultsAnyscaleUrl := terraform.OutputRequired(t, terraformOptions, "all_defaults_url")
	assert.Contains(t, allDefaultsAnyscaleUrl, "gs://anyscale-")

	// Kitchen Sink Test
	kitchenSyncNameOutput := terraform.OutputRequired(t, terraformOptions, "kitchen_sink_bucketname")
	assert.Equal(t, kitchenSyncNameOutput, "anyscale-terraform-test-bucket")
	gcp.AssertStorageBucketExists(t, kitchenSyncNameOutput)

	kitchenSyncSelfLinkOutput := terraform.OutputRequired(t, terraformOptions, "kitchen_sink_selflink")
	assert.NotEmpty(t, kitchenSyncSelfLinkOutput)

	kitchenSyncUrl := terraform.OutputRequired(t, terraformOptions, "kitchen_sink_url")
	assert.Contains(t, kitchenSyncUrl, "gs://anyscale-")

}

func getGoogleProjectIDFromEnvVar(t *testing.T) string {
	return environment.GetFirstNonEmptyEnvVarOrEmptyString(t, projectEnvVars)
}

var projectEnvVars = []string{
	"GOOGLE_PROJECT_ID",
	"PROJECT_ID",
}
