output "bucket_info" {
  value       = "aws_s3_bucket.bucket1"
}

output aws_caller_info  {
  value       = "data.aws_caller_identity.current"
}
