terraform {
  required_version = ">= 0.12"
  backend s3 {
    bucket          = "terraform-state" # should be already created
    key             = "terraform-state-api-deployment"
    region          = "us-east-1"
    dynamodb_table  = "terraform_state_lock" # should already be created
  }
}
