resource "digitalocean_droplet" "docker_swarm_worker" {
  count  = 2
  name   = "docker-swarm-worker-${count.index}"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  image  = "rancheros"
  ssh_keys = [
    "${var.ssh_fingerprint}",
  ]
  private_networking = true

  connection {
    host        = "${self.ipv4_address}"
    user        = "${var.ssh_user}"
    type        = "ssh"
    private_key = "${file(var.ssh_key)}"
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm join --token ${data.external.swarm_join_token.result.worker} ${digitalocean_droplet.leader1.ipv4_address_private}:2377"
    ]
  }
}

data "external" "swarm_join_token" {
  program = ["ops/scripts/get-join-tokens.sh"]
  query = {
    host = "${digitalocean_droplet.leader1.ipv4_address}"
  }
  depends_on = ["digitalocean_droplet.leader1"]
}
