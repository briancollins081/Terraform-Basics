provider "aws" {
    region = "us-east-2"
    version = "~> 2.0"
}   

provider "aws" {
    alias = "aws.virginia"
    region = "us-east-1"
    version = "~> 2.0"
}

resource "aws_s3_bucket" "virginia_bucket" { // will use the provider given
  provider = aws.aws.virginia
  bucket = "s3_spring_photos"
}

resource "aws_s3_bucket" "default_bucket" { // will use the default provider
  bucket = "s3_spring_store"
}