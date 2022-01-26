provider "aws" {
  region = "us-east-2"
}

module "vpc_module" {
  source              = "./vpc_networking"
  vpc_cidr_block      = var.vpc_cidr_block
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}
