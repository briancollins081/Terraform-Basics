provider "aws" {
    region          = "us-east-2"
}

resource "aws_instance" "helloworld" {
    ami             = "ami-0b2c83ee6b2124d49"
    instance_type   = "t2.micro"
    tags            = {
        Name = "HelloWorld"
    }
}