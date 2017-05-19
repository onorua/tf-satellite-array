output "balancer_ips" {
  value = ["${concat("${digitalocean_loadbalancer.satellite.*.ip}", "${aws_elb.satellite.*.ip}")}"]
}
