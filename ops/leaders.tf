# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "ssh_key" {}
variable "ssh_fingerprint" {}
variable "ci_ssh_fingerprint" {}
variable "ssh_user" {}

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
  user_data = <<EOF
#cloud-config
write_files:
- content: |+
    PrintMotd no
    AcceptEnv LANG LC_*
    Subsystem sftp /usr/lib/openssh/sftp-server
    ClientAliveInterval 180
    UseDNS no
    PermitRootLogin no
    AllowGroups docker
    AcceptEnv GITHUB_SHA
  owner: root
  path: /etc/ssh/sshd_config
  permissions: "0600"
  EOF

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
      "sudo mkdir /opt/traefik",
      "sudo touch /opt/traefik/acme.json",
      "sudo chmod 600 /opt/traefik/acme.json",
      # Init the swarm cluster
      "docker swarm init --advertise-addr ${digitalocean_droplet.leader1.ipv4_address_private}",
      "docker network create --driver=overlay traefik-net"
    ]
  }
}
