
provider "aws" {
  region = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

module "vpc" {
  source = "modules/vpc"
  vpc_name = "test-vpc1"
  environment = "${var.environment}"
  allowed_ip = "${var.allowed_ip}"
  bastion_ssh_key_public_file = "${var.bastion_ssh_key_public_file}"
}

module "vpc2" {
  source = "modules/vpc"
  vpc_name = "test-vpc2"
  environment = "${var.environment}"
  allowed_ip = "${var.allowed_ip}"
  bastion_ssh_key_public_file = "${var.bastion_ssh_key_public_file}"
}

output "bastion_host_ip" {
  value = "${module.vpc.bastion_host_ip}"
}
