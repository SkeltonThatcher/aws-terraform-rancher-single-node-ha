## VPC + subnets + IGW

resource "aws_vpc" "rancher" {
  cidr_block           = "${var.cidr_prefix}.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name = "${var.env_name}-rancher"
  }
}

# Public subnets

resource "aws_subnet" "pub_a" {
  vpc_id            = "${aws_vpc.rancher.id}"
  cidr_block        = "${var.cidr_prefix}.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags {
    Name = "${var.env_name}-pub-a"
  }
}

resource "aws_subnet" "pub_b" {
  vpc_id            = "${aws_vpc.rancher.id}"
  cidr_block        = "${var.cidr_prefix}.2.0/24"
  availability_zone = "${var.aws_region}b"

  tags {
    Name = "${var.env_name}-pub-b"
  }
}

# Private subnets

resource "aws_subnet" "priv_a" {
  vpc_id            = "${aws_vpc.rancher.id}"
  cidr_block        = "${var.cidr_prefix}.3.0/24"
  availability_zone = "${var.aws_region}a"

  tags {
    Name = "${var.env_name}-priv-a"
  }
}

resource "aws_subnet" "priv_b" {
  vpc_id            = "${aws_vpc.rancher.id}"
  cidr_block        = "${var.cidr_prefix}.4.0/24"
  availability_zone = "${var.aws_region}b"

  tags {
    Name = "${var.env_name}-priv-b"
  }
}

# Internet gateway + public route table

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.rancher.id}"

  tags {
    Name = "${var.env_name}-rancher"
  }
}

resource "aws_route_table" "rancher" {
  vpc_id = "${aws_vpc.rancher.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${var.env_name}-rancher"
  }
}

# Route table associations

resource "aws_route_table_association" "pub_a" {
  subnet_id      = "${aws_subnet.pub_a.id}"
  route_table_id = "${aws_route_table.rancher.id}"
}

resource "aws_route_table_association" "pub_b" {
  subnet_id      = "${aws_subnet.pub_b.id}"
  route_table_id = "${aws_route_table.rancher.id}"
}
