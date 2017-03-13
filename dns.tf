## Route53 DNS

# DNS zone

data "aws_route53_zone" "selected" {
  name         = "${var.dns_zone}"
  private_zone = false
}

# R53 alias record

resource "aws_route53_record" "rancher" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.env_name}.${data.aws_route53_zone.selected.name}"
  type    = "A"

  alias {
    name                   = "${aws_alb.rancher.dns_name}"
    zone_id                = "${aws_alb.rancher.zone_id}"
    evaluate_target_health = true
  }
}
