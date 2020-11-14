variable "region" {
  default = "ap-northeast-1"
}

variable "prefix_name" {
  default = "nutriform-test"
}

variable "bucket_name" {
  default = "nutriforrm-bucket"
}

data "aws_ami" "ubuntu-ami" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20200907"]
    }
    owners = ["099720109477"] # Canonical
}