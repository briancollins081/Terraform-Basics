output archive_path {
  value       = data.external.lambda_archive.result.archive
  description = "Path of the archive file."
}

output source_code_hash {
    description = "Base64 encoded SHA256 hash of the archive file"
    value       = data.external.lambda_archive.result.base64sha256
}
