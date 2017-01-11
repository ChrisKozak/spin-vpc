

variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_profile" {
  default = "default"
}

variable "aws_amis" {
  default = {
    eu-west-1 = "ami-ac772edf"
  }
}

variable "test_instance_ssh_key_public_file" {
  default = "~/.ssh/spin-test-instance-key.pub"
}

variable "bastion_ssh_key_public_file" {
  default = "~/.ssh/spin-bastion-key.pub"
}

variable "environment" {}
variable "allowed_ip" {}
