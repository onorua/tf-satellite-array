provider "aws" {
  alias = "local"
  access_key = "${module.creds.aws_access_key_id}"
  secret_key = "${module.creds.aws_secret_access_key}"
  region = "${coalesce("${var.aws_region}","us-east-1")}"
}

# Declare the data source
data "aws_availability_zones" "available" {}

resource "aws_instance" "node" {
  provider          = "aws.local"
  ami               = "${coalesce("${var.image}","ami-a3cbb0b4")}"
  instance_type     = "${coalesce("${var.size}","m3.medium")}"
  key_name          = "${module.creds.do_key_name}"
  count             = "${lookup(map("aws", "${var.nodes}"), "${var.provider}" , "0")}"
  availability_zone = "${element(split(",", var.location), count.index)}"

  tags {
    Name = "${var.name_prefix}-${var.location}-${var.deployment}-${count.index}"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["ami", "instance_type"]
  }

  connection {
    user        = "${coalesce("${var.user}","ubuntu")}"
    type        = "ssh"
    private_key = "${module.creds.do_priv_key}"
    timeout     = "2m"
    port        = "${var.ssh_port}"
  }
}

resource "aws_elb" "satellite" {
  count  = "${var.provider == "aws" ? 1 : 0}"
  name               = "${var.name_prefix}-lb-${var.location}-${var.deployment}-${random_id.loadbalancer.hex}"
  availability_zones = "${data.aws_availability_zones.available.names}"

  access_logs {
    bucket        = "foo"
    bucket_prefix = "bar"
    interval      = 60
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = ["${aws_instance.node.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "satellite-terraform-elb"
  }
}
