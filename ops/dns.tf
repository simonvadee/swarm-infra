
# DIGITALOCEAN DNS
resource "digitalocean_domain" "default" {
  name       = "vadee.xyz"
  ip_address = "${digitalocean_droplet.leader1.ipv4_address}"
}
resource "digitalocean_record" "CNAME-www" {
  domain = "${digitalocean_domain.default.name}"
  type   = "CNAME"
  name   = "www"
  value  = "@"
}

resource "digitalocean_record" "wildcard-subdomains" {
  domain = "${digitalocean_domain.default.name}"
  type   = "A"
  name   = "*"
  value  = "${digitalocean_droplet.leader1.ipv4_address}"
}


# COUDFLARE DNS

resource "cloudflare_record" "cl-main" {
  domain = "${digitalocean_domain.default.name}"
  type   = "A"
  name   = "vadee.xyz"
  value  = "${digitalocean_droplet.leader1.ipv4_address}"
}

resource "cloudflare_record" "cl-CNAME-www" {
  domain = "${digitalocean_domain.default.name}"
  type   = "CNAME"
  name   = "www"
  value  = "vadee.xyz"
}

resource "cloudflare_record" "cl-wildcard-subdomains" {
  domain = "${digitalocean_domain.default.name}"
  type   = "A"
  name   = "*"
  value  = "${digitalocean_droplet.leader1.ipv4_address}"
}
