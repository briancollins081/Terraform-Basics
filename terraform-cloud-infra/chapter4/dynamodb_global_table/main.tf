provider "aws" {
  alias  = "oregon"
  region = "us-east-1"
}

provider "aws" {
  alias  = "ohio"
  region = "us-east-2"
}

resource "aws_dynamodb_table" "us-east-1-table" {
  provider         = aws.oregon
  hash_key         = "myAttribute"
  name             = "myTable"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  read_capacity    = 10
  write_capacity   = 10
  attribute {
    name = "myAttribute"
    type = "S"
  }
}


resource "aws_dynamodb_table" "us-east-2-table" {
  provider         = aws.ohio
  hash_key         = "myAttribute"
  name             = "myTable"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  read_capacity    = 10
  write_capacity   = 10
  attribute {
    name = "myAttribute"
    type = "S"
  }
}


resource "aws_dynamodb_global_table" "bloom_lessons_gtable" {
  depends_on = [
    aws_dynamodb_table.us-east-1-table, aws_dynamodb_table.us-east-2-table
  ]
  name     = "myTable"
  provider = aws.ohio

  replica {
      region_name = "us-east-1"
  }

  replica {
      region_name = "us-east-2"
  }
}
