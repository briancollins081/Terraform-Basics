output greeting {
  value       = "Hello Terraform"
}

provider "random" {}


resource random_password random_passwd {
  length  = length
  upper   = true
  lower   = true
  number  = true
  special = true

  keepers = {
    id = "value-1"
  }
}

