
# Configure the DigitalOcean Provider
variable "do_token" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

# Configure the Cloudflare provider
variable "cloudflare_email" {}
variable "cloudflare_token" {}

provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}
