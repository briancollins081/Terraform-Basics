variable "name" {
  type        = string
  description = "Name of the kubernetes cluster"
}


variable "kubernetes_version" {
  type        = string
  description = "Version of Kubernetes control panel to deploy"
}


variable "vpc_cidr" {
  type        = string
  description = "CIDR for vpc"
  default     = "10.0.0.0/24"
}

variable "private_subnets" {
  type        = list
  description = "Private subnet CIDRs"
  default     = [
    "10.0.0.1/24",
    "10.0.0.2/24"
  ]
}


variable "public_subnets" {
  type        = list
  description = "Public subnet CIDRs"
  default     = [
    "10.0.0.4/24",
    "10.0.0.5/24"
  ]
}

variable "worker_instance_type" {
  description = "The EC2 Instance type to create for workers"
  default     = "t2.small"
}

variable "max_workers" {
  description = "The maximum number of instances to maintain in the worker pool"
  default     = 10
}

variable "desired_capacity" {
  description = "The number of instances to launch and maintain in the worker pool"
  default     = 1
}

variable "map_roles" {
  description  = <<-EOT
    List of role mapping data structures to configure the AWS IAM Authenticator.
    See: https://github.com/kubernetes-sigs/aws-iam-authenticator#full-configuration-format
    [{
      rolearn = "arn:aws:iam::000000000000:role/KubernetesAdmin"
      username = "kubernetes-admin"
      groups = ["system:masters"]
    }]
  EOT
  type          = list
  default       = []
}

