variable "number_of_buckets" {
  default = 1
}

resource "aws_s3_bucket" "bloom_lessons_bucket" {
  #   count  = length(var.number_of_buckets)
  count  = var.number_of_buckets > 0 ? var.number_of_buckets : 1
  bucket = "bloom_lessons_images_s3"
}
