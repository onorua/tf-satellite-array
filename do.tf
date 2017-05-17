resource "digitalocean_droplet" "worker" {
  name               = "${var.name_prefix}-${count.index + 1}"
  size               = "${coalesce("${var.size}","512mb")}"
  image              = "${coalesce("${var.image}","ubuntu-16-04-x64")}"
  region             = "${element(split(",", coalesce(var.location,"nyc3")), count.index)}"
  count              = "${lookup(map("do", "${var.nodes}"), "${var.provider}" , "0")}"
  private_networking = "true"
  ssh_keys           = ["${module.creds.do_ssh_fingerprint}"]

  lifecycle {
    create_before_destroy = true
  }

  connection {
    user        = "${coalesce("${var.user}","root")}"
    type        = "ssh"
    private_key = "${module.creds.do_priv_key}"
    timeout     = "2m"
    port        = "${var.ssh_port}"
  }
}

resource "digitalocean_loadbalancer" "lb" {
  name   = "sat-lb-${coalesce(var.location,"nyc3")}-${count.index + 1}"
  region = "${element(split(",", coalesce(var.location,"nyc3")), count.index)}"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  forwarding_rule {
    entry_port     = 81
    entry_protocol = "http"

    target_port     = 81
    target_protocol = "http"
  }

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "tcp"

    target_port     = 443
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_port     = 444
    entry_protocol = "tcp"

    target_port     = 444
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_port     = 9001
    entry_protocol = "tcp"

    target_port     = 9001
    target_protocol = "tcp"
  }

  healthcheck {
    port                     = 22
    protocol                 = "tcp"
    response_timeout_seconds = 1
    check_interval_seconds   = 3
  }

  droplet_ids = ["${digitalocean_droplet.worker.*.id}"]
}
