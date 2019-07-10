
# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.do_token}"
}

# Configure the Cloudflare provider
provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}
