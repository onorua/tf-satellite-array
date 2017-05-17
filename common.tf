module "creds" {
  source = "git::ssh://git@github.com/AnchorFree/tf_af_creds.git"
}

provider "aws" {
  access_key = "${module.creds.aws_access_key_id}"
  secret_key = "${module.creds.aws_secret_access_key}"
  region     = "us-east-1"
}

provider "digitalocean" {
  token = "${module.creds.do_token}"
}
