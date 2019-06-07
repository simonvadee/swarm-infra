# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {}
variable "ssh_key" {}
variable "ssh_fingerprint" {}
variable "ci_ssh_fingerprint" {}
variable "ssh_user" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.do_token}"
}

# Swarm leader
resource "digitalocean_droplet" "leader1" {
  image              = "rancheros"
  name               = "leader1"
  region             = "fra1"
  size               = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys = [
    "${var.ssh_fingerprint}",
    "${var.ci_ssh_fingerprint}"
  ]

  connection {
    host        = "${self.ipv4_address}"
    user        = "${var.ssh_user}"
    type        = "ssh"
    private_key = "${file(var.ssh_key)}"
    timeout     = "2m"
  }

  # Configure the provisioned machine
  provisioner "remote-exec" {
    inline = [
      # Init the swarm cluster
      "docker swarm init --advertise-addr ${digitalocean_droplet.leader1.ipv4_address}",
      "docker network create --driver=overlay traefik-net"
    ]
  }
}
