package main

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestVPC(t *testing.T) {
	t.Parallel()
	approvedRegions := []string{"us-east-1"}
	awsRegion := aws.GetRandomRegion(t, approvedRegions, nil)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../modules/vpc",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"region": awsRegion,
			"default_tags": map[string]string{
				"Environment":   "uat",
				"Is Production": "No",
			},
		},
	}

	// At the end of the test, run `terraform destroy`
	defer terraform.Destroy(t, terraformOptions)
	// Run `terraform init` and `terraform apply`
	terraform.InitAndApply(t, terraformOptions)

	vpcID := terraform.Output(t, terraformOptions, "vpc_id")
	vpcRegion := (terraformOptions.Vars["region"]).(string)

	t.Logf("outputvpcID = %v", vpcID)
	t.Logf("vpcRegion from Vars = %v", vpcRegion)

	actualVpcID := aws.GetVpcById(t, vpcID, vpcRegion)
	t.Run("correct VPC ID", func(t *testing.T) {
		if actualVpcID.Id != vpcID {
			t.Errorf("VPC ID incorrect. got: %v, want: %v\n", actualVpcID.Id, vpcID)
		}
	})

	subnets := aws.GetSubnetsForVpc(t, vpcID, awsRegion)
	t.Run("less than 1 subnet", func(t *testing.T) {
		if len(subnets) < 1 {
			t.Error("only 1 subnet deployed")
		}
	})

	for _, subnet := range subnets {
		t.Log(subnet.AvailabilityZone)
		t.Log(subnet.Id)
	}

	// TODO: Check if the subnets are public?

	vpc := aws.GetVpcById(t, actualVpcID.Id, awsRegion)
	vpcTagsInjected := terraformOptions.Vars["default_tags"]

	t.Run("check for VPC tag 'Name'", func(t *testing.T) {
		vpcTagsMap := vpcTagsInjected.(map[string]string)
		if vpcTagName, ok := vpcTagsMap["Environment"]; !ok {
			t.Errorf("vpc tag Environment not configured. got: %v, want: %v\n", vpcTagName, vpc.Name)

			nameTag := fmt.Sprintf("%s-vpc", vpcTagsMap["Environment"])
			if nameTag != vpc.Name {
				t.Errorf("incorrect tag value for Name, got: %v, want: %v\n", vpcTagName, vpc.Name)
			}
		}
	})
}
