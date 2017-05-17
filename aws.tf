provider "aws" {
  alias = "local"
  access_key = "${module.creds.aws_access_key_id}"
  secret_key = "${module.creds.aws_secret_access_key}"
  region = "${coalesce("${var.aws_region}","us-east-1")}"
}

resource "aws_instance" "node" {
  provider          = "aws.local"
  ami               = "${coalesce("${var.image}","ami-a3cbb0b4")}"
  instance_type     = "${coalesce("${var.size}","m3.medium")}"
  key_name          = "${module.creds.do_key_name}"
  count             = "${lookup(map("aws", "${var.nodes}"), "${var.provider}" , "0")}"
  availability_zone = "${element(split(",", var.location), count.index)}"

  tags {
    Name = "${var.name_prefix}-${count.index}"
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
