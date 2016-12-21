
resource "aws_key_pair" "spinkeys" {
  key_name   = "spinkeys-${var.environment}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "test_server" {
  tags {
    Name = "Spin VPC Test Server"
    Environment = "${var.environment}"
  }
  instance_type = "t2.micro"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  vpc_security_group_ids = ["${module.vpc.common_private_security_group_id}"]
  subnet_id = "${module.vpc.private_subnet_id}"
  key_name = "${aws_key_pair.spinkeys.id}"
}

output "test_server_ip" {
  value = "${aws_instance.test_server.private_ip}"
}
