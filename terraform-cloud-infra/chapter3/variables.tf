variable "bucket_name" {
#   default = "s3_bloom_lessons" // use tfvars value
  description = "Bucket name for S3"
}

resource "aws_s3_bucket" "variable_s3_bucket" {
#   bucket = "bloom_lessons_${var.bucket_name}"
  bucket = var.bucket_name == "" ? "bloom_lessons_s3" : "bloom_lessons_${var.bucket_name}"
}

locals {
  instance_name = "dev_instance"
  instance_type = "t2.micro"
}

resource "aws_instance" "dev_bloom_api" {
  ami = "ami-423445gdfs"
  instance_type = local.instance_type
  tags = {
      Name = local.instance_name
  }
} 