# Configure the Scaleway Provider
variable "sw_token" {}
variable "sw_org_id" {}

provider "scaleway" {
  organization = "${var.sw_org_id}"
  token        = "${var.sw_token}"
  region       = "${var.region}"
}
data "scaleway_bootscript" "debian" {
  architecture = "x86_64"
  name = "x86_64 mainline 4.14.128 rev1"
}

data "scaleway_image" "debian_stretch" {
  architecture = "x86_64"
  name         = "Debian Stretch"
}

data "template_file" "docker_conf" {
  template = "${file("ops/conf/docker.tpl")}"

  vars = {
    ip = "${var.docker_api_ip}"
  }
}

resource "scaleway_ssh_key" "test" {
    key = "${file("~/.ssh/id_rsa.pub")}"
}


# Configure the Cloudflare provider
variable "cloudflare_token" {}

provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}
