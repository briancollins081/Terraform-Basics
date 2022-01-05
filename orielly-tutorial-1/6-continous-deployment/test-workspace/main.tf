//--------------------------------------------------------------------
// Modules
terraform {
  required_version = ">= 0.12"
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "briancollins081"
    workspaces {
      name = "test"
    }
  }
}

module "lambda_python_archive" {
  source  = "app.terraform.io/briancollins081/lambda-python-archive/aws"
  version = "0.1.6"

  install_dependencies = "true"
  output_path = "${path.module}/artifacts/lambda.zip"
  src_dir = "${path.module}/python"
}