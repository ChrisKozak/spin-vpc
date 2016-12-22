
provider "aws" {
  region = "${var.aws_region}"
  profile = "default"
}

module "vpc" {
  source = "modules/vpc"
  service_name = "Spin VPC Tester"
  environment = "${var.environment}"
  allowed_ip = "${var.allowed_ip}"
  bastion_ssh_key_public_file = "${var.bastion_ssh_key_public_file}"
}

output "bastion_host_ip" {
  value = "${module.vpc.bastion_host_ip}"
}
