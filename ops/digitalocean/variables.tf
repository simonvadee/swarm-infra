variable "do_token" {}

variable "cloudflare_email" {
  default = "simon.vadee@gmail.com"
}

variable "cloudflare_token" {}

variable "ssh_key" {
    default = "~/.ssh/id_rsa"
}
variable "ssh_user" {
    default = "rancher"
}

variable ssh_fingerprint {
    default=  "c5:2a:79:ce:c5:3f:46:ce:97:13:0b:4d:54:87:3b:7e"
}

variable ci_ssh_fingerprint {
    default=  "72:c7:9e:49:f9:00:5f:31:37:2e:87:43:7c:56:22:c9"
}