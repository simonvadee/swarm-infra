# COUDFLARE DNS

resource "cloudflare_record" "cl-main" {
  domain = "vadee.xyz"
  type   = "A"
  name   = "vadee.xyz"
  value  = "${scaleway_ip.swarm_manager_ip.0.ip}"
}

# resource "cloudflare_record" "cl-CNAME-www" {
#   domain = "www.vadee.xyz"
#   type   = "CNAME"
#   name   = "www"
#   value  = "vadee.xyz"
# }

resource "cloudflare_record" "cl-wildcard-subdomains" {
  domain = "vadee.xyz"
  type   = "A"
  name   = "*"
  value  = "${scaleway_ip.swarm_manager_ip.0.ip}"
}
