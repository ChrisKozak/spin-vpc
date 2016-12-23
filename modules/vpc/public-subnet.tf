
variable "availability_zones" {
  default = {
    eu-west-1 = "eu-west-1a,eu-west-1b,eu-west-1c"
    eu-west-2 = "eu-west-2a,eu-west-2b"
  }
}

variable "public_ranges" {
  default = "10.0.1.0/24,10.0.2.0/24,10.0.3.0/24"
}

resource "aws_internet_gateway" "vpc_module" {
  tags {
    Name = "${var.service_name} Gateway"
    Environment = "${var.environment}"
  }
  vpc_id = "${aws_vpc.vpc_module.id}"
}

resource "aws_subnet" "public_subnet" {
  count = "${length(split(",", lookup(var.availability_zones, var.aws_region)))}"
  tags { 
    Name = "${var.service_name} Public Subnet in ${element(split(",", lookup(var.availability_zones, var.aws_region)),count.index)}"
    Environment = "${var.environment}"
  }
  availability_zone = "${element(split(",", lookup(var.availability_zones, var.aws_region)),count.index)}"
  cidr_block        = "${element(split(",", var.public_ranges), count.index)}"
  vpc_id = "${aws_vpc.vpc_module.id}"
  map_public_ip_on_launch = true
}

# resource "aws_subnet" "public_subnet" {
#   tags {
#     Name = "${var.service_name} Public Subnet"
#     Environment = "${var.environment}"
#   }
#   vpc_id = "${aws_vpc.vpc_module.id}"
#   cidr_block = "10.0.1.0/24"
#   map_public_ip_on_launch = true
# }

resource "aws_route_table" "public_routes" {
  count = "${length(split(",", lookup(var.availability_zones, var.aws_region)))}"
  tags {
    Name = "${var.service_name} Public Route Table ${count.index}"
    Environment = "${var.environment}"
  }
  vpc_id = "${aws_vpc.vpc_module.id}"
}

resource "aws_route" "public_gateway_route" {
  count = "${length(split(",", lookup(var.availability_zones, var.aws_region)))}"
  route_table_id = "${element(aws_route_table.public_routes.*.id, count.index)}"
  depends_on = ["aws_route_table.public_routes"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.vpc_module.id}"
}

resource "aws_route_table_association" "route_public_subnet" {
  count = "${length(split(",", lookup(var.availability_zones, var.aws_region)))}"
  subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public_routes.*.id, count.index)}"
  # route_table_id = "${aws_route_table.public_routes.id}"
}
