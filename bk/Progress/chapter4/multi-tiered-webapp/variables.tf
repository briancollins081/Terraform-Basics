variable namespace {
  type        = string
  description = "The project namespace to use for uniques resource naming"
}

variable ssh_keypair {
  type        = string
  default     = null
  description = "SSH Key pair to use for EC2 Instances"
}


variable region {
  type        = string
  default     = "us-east-2"
  description = "AWS Region"
}

