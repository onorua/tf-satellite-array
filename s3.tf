# S3 - Hostfile Storage
resource "aws_s3_bucket_object" "host_ips_file" {
    bucket = "tf_af_hostarray"
    key = "hosts/${var.name_prefix}"
    content = "${join("\n",formatlist("%v   %v", concat(digitalocean_droplet.node.*.ipv4_address, aws_instance.node.*.public_ip), concat(digitalocean_droplet.node.*.name, aws_instance.node.*.tags.Name)))}\n"
    content_type = "text/plain"
    etag = "${md5("${join("\n",formatlist("%v   %v", concat(digitalocean_droplet.node.*.ipv4_address, aws_instance.node.*.public_ip), concat(digitalocean_droplet.node.*.name, aws_instance.node.*.tags.Name)))}\n")}"
    count  = "${lookup(map("do", "${signum(var.nodes)}"), "${var.provider}" , "0")}"
}

# S3 - Hostfile Storage for private IPs
resource "aws_s3_bucket_object" "host_private_ips_file" {
    bucket = "tf_af_hostarray"
    key = "hosts_private/${var.name_prefix}"
    content = "${join("\n",formatlist("%v %v", concat(digitalocean_droplet.node.*.ipv4_address_private, aws_instance.node.*.private_ip), concat(digitalocean_droplet.node.*.name, aws_instance.node.*.tags.Name)))}\n"
    content_type = "text/plain"
    etag = "${md5("${join("\n",formatlist("%v %v", concat(digitalocean_droplet.node.*.ipv4_address_private,aws_instance.node.*.private_ip), concat(digitalocean_droplet.node.*.name, aws_instance.node.*.tags.Name)))}\n")}"
    count  = "${lookup(map("do", "${signum(var.nodes)}"), "${var.provider}", "0")}"
}
