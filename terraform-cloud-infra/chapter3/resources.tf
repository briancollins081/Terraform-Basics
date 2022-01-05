provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-2w323213"
  instance_type = "t2.micro"
  key_name      = data.aws_instance.ec2_data.key_name 
  tags          = {
      Name = "bloom_lessons_test_instance"
  }
}

data "aws_instance" "ec2_data" {
  instance_id = "546436483hse"
}

data "aws_vpc" "default_vpc" {
  cidr_block = "10.0.0.0/16"
}
