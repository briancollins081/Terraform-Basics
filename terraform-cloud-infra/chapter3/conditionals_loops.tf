variable "number_of_buckets" {
  default = 1
}

resource "aws_s3_bucket" "bloom_lessons_bucket" {
  #   count  = length(var.number_of_buckets)
  count  = var.number_of_buckets > 0 ? var.number_of_buckets : 1
  bucket = "bloom_lessons_images_s3"
}

variable "users" {
  default = ["batman", "superman", "ironman"]
}

resource "aws_iam_user" "users" {
  for_each = toset(var.users)
  name     = each.value
}

variable "asg_tags" {
  type = map(string)
  default = {
    Name = "ASG_EC2"
    Type = "m4.large"
    Team = "DEV   "
  }
}
resource "aws_autoscaling_group" "asg" {
  max_size = 0
  min_size = 0
  dynamic "tag" {
    for_each = var.asg_tags
    content = {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

output "uppercase_heroes" {
  value = [
    for hero in var.users : upper(hero) if length(hero) < 7
  ]
}
