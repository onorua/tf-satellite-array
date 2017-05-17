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
  name   = "loadbalancer-1"
  region = "nyc3"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_ids = ["${digitalocean_droplet.web.id}"]
}
