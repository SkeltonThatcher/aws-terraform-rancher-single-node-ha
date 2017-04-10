## Rancher server + launch config + autoscaling group + security group

# Server security group

resource "aws_security_group" "rancher_srv" {
  name        = "${var.env_name}-rancher-srv"
  vpc_id      = "${aws_vpc.rancher.id}"
  description = "Rancher server group"

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.rancher_alb.id}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.env_name}-rancher-srv"
  }
}

# User-data template

data "template_file" "userdata_srv" {
  template = "${file("./files/userdata_srv.template")}"

  vars {
    # Database
    database_address  = "${aws_db_instance.rancher.address}"
    database_name     = "${var.db_name}"
    database_username = "${var.db_username}"
    database_password = "${var.db_password}"
  }
}

# Server launch configuration

resource "aws_launch_configuration" "rancher_srv" {
  image_id                    = "${lookup(var.ami_type, var.aws_region)}"
  instance_type               = "${var.srv_size}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.rancher_srv.id}"]
  associate_public_ip_address = true
  user_data                   = "${data.template_file.userdata_srv.rendered}"
}

# Server auto scaling group

resource "aws_autoscaling_group" "rancher_srv" {
  name                      = "${var.env_name}-rancher-srv"
  availability_zones        = ["${var.aws_region}a", "${var.aws_region}b"]
  launch_configuration      = "${aws_launch_configuration.rancher_srv.name}"
  health_check_grace_period = 500
  health_check_type         = "EC2"
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = ["${aws_subnet.pub_a.id}", "${aws_subnet.pub_b.id}"]
  target_group_arns         = ["${aws_alb_target_group.rancher.id}"]

  tag {
    key                 = "Name"
    value               = "${var.env_name}-rancher-srv"
    propagate_at_launch = true
  }

  provisioner "local-exec" {
    command = "./set_access_control.sh \"${var.rancher_admin_name}\" \"${var.rancher_admin_password}\" \"${var.rancher_admin_username}\" \"http://${var.env_name}.${data.aws_route53_zone.selected.name}:8080\""
  }
}
