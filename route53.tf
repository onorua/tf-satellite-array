#resource "aws_route53_record" "colo-name" {
#  zone_id = "${var.aws_zone_id}"
#  name = "${var.location}.${var.deployment}"
#  type = "A"
#  ttl = "${var.ttl}"
#  records = ["${concat("${digitalocean_loadbalancer.satellite.*.ip}", "${aws_elb.satellite.*.ip}")}"]
#}
