resource "aws_route53_record" "balancer" {
  zone_id = "${var.aws_zone_id}"
  name = "${var.name_prefix}"
  type = "A"
  ttl = "${var.ttl}"

  weighted_routing_policy {
    weight = "${var.weight}"
  }

  set_identifier = "${var.name_prefix}"
  records = ["${concat("${digitalocean_loadbalancer.satellite.*.ip}", "${aws_elb.satellite.*.ip}")}"]
}
