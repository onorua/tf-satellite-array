# S3 - Hostfile Storage
resource "aws_s3_bucket_object" "do_hosts" {
    bucket = "tf_af_hostarray"
    key = "hosts/${var.name_prefix}"
    content = "${join("\n",formatlist("%v   %v", digitalocean_droplet.node.*.ipv4_address, digitalocean_droplet.node.*.name))}\n"
    content_type = "text/plain"
    etag = "${md5("${join("\n",formatlist("%v   %v", digitalocean_droplet.node.*.ipv4_address, digitalocean_droplet.node.*.name))}\n")}"
    count  = "${lookup(map("do", "${signum(var.nodes)}"), "${var.provider}" , "0")}"
}

# S3 - Hostfile Storage for private IPs
resource "aws_s3_bucket_object" "do_hosts_private" {
    bucket = "tf_af_hostarray"
    key = "hosts_private/${var.name_prefix}"
    content = "${join("\n",formatlist("%v %v", digitalocean_droplet.node.*.ipv4_address_private, digitalocean_droplet.node.*.name))}\n"
    content_type = "text/plain"
    etag = "${md5("${join("\n",formatlist("%v %v", digitalocean_droplet.node.*.ipv4_address_private, digitalocean_droplet.node.*.name))}\n")}"
    count  = "${lookup(map("do", "${signum(var.nodes)}"), "${var.provider}", "0")}"
}

# S3 - Hostfile Storage
resource "aws_s3_bucket_object" "aws_hosts" {
    bucket = "tf_af_hostarray"
    key = "hosts/${var.name_prefix}"
    content = "${join("\n",formatlist("%v   %v", aws_instance.node.*.public_ip, aws_instance.node.*.tags.Name))}\n"
    content_type = "text/plain"
    etag = "${md5("${join("\n",formatlist("%v   %v", aws_instance.node.*.public_ip, aws_instance.node.*.tags.Name))}\n")}"
    count  = "${lookup(map("aws", "${signum(var.nodes)}"), "${var.provider}" , "0")}"
}

# S3 - Hostfile Storage for private IPs
resource "aws_s3_bucket_object" "aws_hosts_private" {
    bucket = "tf_af_hostarray"
    key = "hosts_private/${var.name_prefix}"
    content = "${join("\n",formatlist("%v %v", aws_instance.node.*.private_ip, aws_instance.node.*.tags.Name))}\n"
    content_type = "text/plain"
    etag = "${md5("${join("\n",formatlist("%v %v", aws_instance.node.*.private_ip, aws_instance.node.*.tags.Name))}\n")}"
    count  = "${lookup(map("aws", "${signum(var.nodes)}"), "${var.provider}" , "0")}"
}
