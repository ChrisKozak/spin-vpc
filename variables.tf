
variable "environment" {
  default = "VPC Testing Sandbox"
}

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
  default = "/home/vagrant/.ssh/spin-test-instance-key.pub"
}

variable "bastion_ssh_key_public_file" {
  default = "/home/vagrant/.ssh/spin-bastion-key.pub"
}

variable "allowed_ip" {}
