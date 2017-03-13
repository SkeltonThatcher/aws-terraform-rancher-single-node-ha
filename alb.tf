## Application load balancer + listener + target group + security group

# ALB security group

resource "aws_security_group" "rancher_alb" {
  name        = "${var.env_name}-rancher-alb"
  vpc_id      = "${aws_vpc.rancher.id}"
  description = "Rancher application load balancer group"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.env_name}-rancher-alb"
  }
}

# ALB

resource "aws_alb" "rancher" {
  name            = "${var.env_name}-rancher"
  internal        = false
  security_groups = ["${aws_security_group.rancher_alb.id}"]
  subnets         = ["${aws_subnet.pub_a.id}", "${aws_subnet.pub_b.id}"]

  enable_deletion_protection = false

  tags {
    Name = "${var.env_name}-rancher"
  }
}

# ALB listener

resource "aws_alb_listener" "rancher" {
  load_balancer_arn = "${aws_alb.rancher.id}"
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.rancher.id}"
    type             = "forward"
  }
}

# ALB target group

resource "aws_alb_target_group" "rancher" {
  name     = "${var.env_name}-rancher"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.rancher.id}"

  health_check {
    path = "/ping"
  }

  tags {
    Name = "${var.env_name}-rancher"
  }
}
