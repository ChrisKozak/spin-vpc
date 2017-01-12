
resource "aws_key_pair" "test_instance_keypair" {
  key_name   = "test_instance_keypair-${var.environment}"
  public_key = "${file(var.test_instance_ssh_key_public_file)}"
}

resource "aws_instance" "test_server" {
  tags {
    Name = "VPC Test for ${var.environment}"
    Environment = "${var.environment}"
  }
  instance_type = "t2.micro"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  vpc_security_group_ids = ["${module.vpc.common_private_security_group_id}"]
  subnet_id = "${module.vpc.private_subnet_id}"
  key_name = "${aws_key_pair.test_instance_keypair.id}"
}

output "test_server_ip" {
  value = "${aws_instance.test_server.private_ip}"
}
