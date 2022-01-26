provider "aws" {
  region = var.region
}

data "aws_caller_identity" "bloom_account" {}

resource "aws_s3_bucket" "bloom_bucket" {
  bucket = "bloom-bucket-${data.aws_caller_identity.bloom_account.account_id}"
  acl    = "public-read"
  versioning {
    enabled = true
  }
  lifecycle_rule {
    prefix  = "files/"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 90
    }
  }
  tags = {
    Type = "LOG"
    Tier = "STANDARD"
  }
}

resource "aws_s3_bucket_policy" "bloom_bucket_policy" {
  bucket = aws_s3_bucket.bloom_bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "BloomBucketPolicy",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.bloom_bucket.bucket}/*",
      "Condition": {
        "IpAddress": {"aws:SourceIp": "4.4.4.4/32"}
      }
    }
  ]
}
  POLICY
}

resource "aws_s3_bucket_object" "readme_file" {
  bucket = aws_s3_bucket.bloom_bucket.bucket
  key    = "files/readme.txt"
  source = "readme.txt"

  etag = filemd5("readme.txt")
}
