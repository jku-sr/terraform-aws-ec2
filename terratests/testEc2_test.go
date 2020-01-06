package main

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestEC2(t *testing.T) {
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/terraform-aws-s3-example",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": "us-east-1",
		},
	}

	// TODO: Check for correct tags
	//tagsReturned := aws.GetEc2InstanceIdsByFilters()
	// TODO: Check for correct AMI ID
	//ami := aws.GetEc2InstanceIdsByTag(t, "", "", "")
	// TODO: Check for correct instance type

	t.Log(terraformOptions)
}
