
variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_amis" {
  default = {
    eu-west-1 = "ami-ac772edf"
  }
}

variable "service_name" {}

variable "environment" {}

variable "allowed_ip" {}

variable "bastion_ssh_key_public_file" {}
