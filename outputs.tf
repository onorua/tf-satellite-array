output "balancer_ips" {
  value = ["${concat("${digitalocean_loadbalancer.satellite.*.ip}", "${aws_elb.satellite.*.ip}")}"]
}

output "balancer_ids" {
  value = ["${concat("${digitalocean_loadbalancer.satellite.*.id}", "${aws_elb.satellite.*.id}")}"]
}

output "fqdn" {
  value = ["${aws_route53_record.balancer.*.fqdn}"]
}
