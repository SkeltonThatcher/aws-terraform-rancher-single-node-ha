## RDS Database + subnet group + security group

# RDS security group

resource "aws_security_group" "rancher_db" {
  name        = "${var.env_name}-rancher-db"
  vpc_id      = "${aws_vpc.rancher.id}"
  description = "Rancher database group"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.rancher_srv.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.env_name}-rancher-db"
  }
}

# RDS subnet group

resource "aws_db_subnet_group" "rancher" {
  name       = "${var.env_name}-rancher"
  subnet_ids = ["${aws_subnet.priv_a.id}", "${aws_subnet.priv_b.id}"]

  tags {
    Name = "${var.env_name}-rancher"
  }
}

# RDS instance

resource "aws_db_instance" "rancher" {
  engine                    = "mysql"
  storage_type              = "gp2"
  instance_class            = "${var.db_class}"
  name                      = "${var.db_name}"
  username                  = "${var.db_username}"
  password                  = "${var.db_password}"
  allocated_storage         = "${var.db_storage}"
  backup_retention_period   = "${var.db_backup_retention}"
  multi_az                  = "${var.db_multi_az}"
  identifier                = "${var.env_name}-rancher"
  db_subnet_group_name      = "${aws_db_subnet_group.rancher.name}"
  vpc_security_group_ids    = ["${aws_security_group.rancher_db.id}"]
  final_snapshot_identifier = "${var.env_name}-snapshot"
  skip_final_snapshot       = "${var.db_final_snapshot}"
}
