terraform {
    required_version = ">= 1.0.11"
    
    required_providers {
      aws = {
          source    = "hashicorp/aws"
          version   = "~> 3.0"
      }
    }
}
data aws_caller_identity current {
    
}

data aws_availability_zones available {
    state = "available"
}

variable bucket_name {
  type        = string
}

locals {
  aws_account = "${lower(data.aws_caller_identity.current.account_id)}-${lower(data.aws_caller_identity.current.user_id)}"
}

provider aws {
    region = "us-east-1"
}

resource aws_s3_bucket terraform_bucket_1 {
    bucket = "${data.aws_caller_identity.current.account_id}-bucket1"
    acl    = "private"
}


resource aws_s3_bucket terraform_bucket_2 { 
    bucket = "${data.aws_caller_identity.current.account_id}-bucket2"
    acl    = "private"
}

# resource aws_s3_bucket terraform_bucket_3 { 
#     bucket = "${data.aws_caller_identity.current.account_id}-bucket3"
#     acl    = "private"
#     depends_on = [
#         aws_s3_bucket.terraform_bucket_1
#     ]
# }

resource aws_s3_bucket terraform_bucket_4 { 
    bucket = var.bucket_name
    acl    = "private"
}

resource aws_s3_bucket terraform_bucket_5 { 
    bucket = "${local.aws_account}"
}

# # Using count
# resource aws_s3_bucket terraform_bucketX { 
#     count  = 2 # change to 0 to skip this - will be destroyed
#     bucket = "${local.aws_account}-${count.index+5}"
# }

# Using a map with foreach
# locals {
#   buckets = {
#     bucket101 = "abcbucket-101"
#     bucket102 = "abcbucket-102"
#   }
# }

# resource "aws_s3_bucket" "buckets_with_foreach_map"{
#     for_each = local.buckets
#     bucket   = "${local.aws_account}-${each.value}"
# }

# Using an array|set
locals {
  buckets2 = [
    "abcbucket2-101",
    "abcbucket2-102"
  ]
}

resource "aws_s3_bucket" "buckets_with_foreach_set"{
    for_each = toset(local.buckets2)
    # bucket   = "${local.aws_account}-${each.value}" # or
    bucket   = "${local.aws_account}-${each.key}"
}


# Data Types

locals {
  myString  = "Mimi ni mzii bana!!"
  myNumber  = 900
  myBoolean = true
  myList    = [
      "element1",
      2,
      "three"
  ]
  myMap     = {
      key1 = "value1"
  }

  # Complex 
  complexDataTypes  = {
      name          = "Brian Andere",
      phone_number  = {
          home  = "254-0000-002-001"
          work  = "254-0000-002-001"
          other  = "254-0000-002-001"
      }
      active        = false
      age           = 20

  }
}

output home_phone {
  value       = local.complexDataTypes.phone_number.home
}




# Operators
locals {
    # Arithmetic
    plus            = 3 + 4
    minus           = 4 - 3
    multiplication  = 9 * 99 * 999 * 9999
    # Logical
    t = true || false
    f = true && false
    # Comparison
    gt  = 2 > 1
    gte = 2 >= 1
    lt  = 2 < 1
    lte = 2 <= 1
    eq  = 2 == 2
    neq = 2 != 7
}

output "arithmetic" {
    value = "${local.plus} - ${local.minus} - ${local.multiplication}"
}

output "logical" {
    value = "${local.t} - ${local.f}"
}

output "comparison" {
    value = "${local.gt} - ${local.gte} - ${local.lt} - ${local.lt} - ${local.lte} - ${local.eq} - ${local.neq}"
}


# Conditionals
variable bucket_count {
    type = number
}

locals {
    minimum_number_of_buckets = 5
    number_of_buckets         = var.bucket_count > 0 ? var.bucket_count : local.minimum_number_of_buckets
}


resource aws_s3_bucket buckets_with_conditionals {
    count   = local.number_of_buckets
    bucket  = "${local.aws_account}-buckets_with_conditionals${count.index + 1}"
}


# Functions
locals {
    ts = timestamp()
    current_month = formatdate("MMMM", local.ts)
    tomorrow = formatdate("DD", timeadd(local.ts, "24h"))
}
output date_time {
    value = "${local.current_month} ${local.tomorrow}"
}

locals {
    formatted       = "${format("Hello %s ", "World")}"
    formatted_list  = "${formatlist("Hello %s ", ["World", "Kenya", "Uganda", "Tanzania", "Djibouti"])}"
}

output formatted_list {
    value = local.formatted_list
}

# Iterations
locals {
    l           = ["one","two", "three", "four"]
    upper_list  = [for item in local.l: upper(item)]
    lower_map   = {for item in local.l: item => lower(item)}
}

output "iterations_upper" {
    value       = local.upper_list
}

output "iterations_lower" {
    value       = local.lower_map
}


# Filtering Example
locals {
    n        = [0,1,2,3,4,5,6,7,8,9,10,11,12]
    even_nos = [for i in local.n: i if i % 2 == 0]
}

output even_numbers {
    value =  local.even_nos
}

# Heredoc + Directives
output heredoc {
    value = <<-EOT
        This is called a `heredoc`. It is a string literal 
        that can span multiple lines
    EOT
}

locals {
  person = {
      name: "Peterson Junly"
  }
}



output directive {
    value = <<-EOT
        This is called a `heredoc` with directives.
        %{ if local.person.name == "" }
        Sorry, I do not know your name.
        %{ else }
        Hi ${local.person.name}
        %{ endif }
    EOT
}


output iterated {
    value = <<-EOT
        Directives can also iterate...
        %{ for number in local.even_nos }
        ${number} is even.
        %{ endfor }
    EOT
}