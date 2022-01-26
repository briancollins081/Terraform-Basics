provider "aws" {
  region = "us-east-2"
}
terraform {
  backend "s3" {
    bucket = "tf-12-remote-states-main"
    key    = "aws_tf_remote_state.tfstates"
    region = "us-east-2"
  }
}
# resource "aws_s3_bucket" "terraform_remote_state_bucket" {
#   bucket = "tf-12-remote-states-main"
# }

resource "aws_security_group" "security_group" {
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
  }
  egress {
    cidr_blocks = ["192.168.1.1/32"]
    from_port   = 0
    protocol    = "TCP"
    to_port     = 0
  }
  tags = {
    Name = "AWS_SG"
  }
}
