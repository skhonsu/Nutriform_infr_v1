variable "prefix_name" {}

variable "vpc_cidr" {
  default = "155.0.0.0/16"
}

variable "public_subnets_cidr" {
  type    = list
  default = ["155.0.1.0/24", "155.0.2.0/24"]
}

variable "private_subnets_cidr" {
  type    = list
  default = ["155.0.3.0/24", "155.0.4.0/24"]
}

variable "azs" {
  type        = list
  description = "AZs to use in your public and private subnet  (make sure they are consistent with your AWS region)"
  default     = ["ca-central-1a", "ca-central-1b"]
}
