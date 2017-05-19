resource "aws_route53_record" "balancer" {
  zone_id = "${var.aws_zone_id}"
  name = "${var.location}.${var.deployment}"
  type = "A"
  ttl = "${var.ttl}"

  weighted_routing_policy {
    weight = "${var.weight}"
  }

  set_identifier = "${random_id.loadbalancer.hex}"
  records = ["${concat("${digitalocean_loadbalancer.satellite.*.ip}", "${aws_elb.satellite.*.ip}")}"]
}
