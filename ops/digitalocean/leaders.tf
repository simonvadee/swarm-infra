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

  # Configure the SSH daemon so it accepts setting environment variables.
  user_data = "${file("ops/conf/cloudinit.conf")}"

  connection {
    host = "${self.ipv4_address}"
    user = "${var.ssh_user}"
    type = "ssh"
    private_key = "${file(var.ssh_key)}"
    timeout = "2m"
  }

  # Configure the provisioned machine
  provisioner "remote-exec" {
    inline = [
      # create traefik directory
      "sudo mkdir /opt/traefik",
      # add a file to store Let's Encrypt certificates
      "sudo touch /opt/traefik/acme.json",
      "sudo chmod 600 /opt/traefik/acme.json",
      # add log files
      "sudo touch /opt/traefik/access.log",
      "sudo touch /opt/traefik/traefik.log",
      # Init the swarm cluster
      "docker swarm init --advertise-addr ${digitalocean_droplet.leader1.ipv4_address_private}",
      "docker network create --driver=overlay traefik-net"
    ]
  }
}
