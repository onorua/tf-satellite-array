resource "random_id" "loadbalancer" {
  byte_length = 4
}

resource "aws_route53_record" "balancer" {
  zone_id = "${var.aws_zone_id}"
  name = "${var.location}.${var.deployment}"
  type = "A"
  ttl = "${var.ttl}"

  weighted_routing_policy {
    weight = "${var.weight}"
  }

  set_identifier = "${random_id.loadbalancer.hex}"
  records = ["${var.balancers}"]
}
