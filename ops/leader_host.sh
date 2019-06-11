cat ops/cluster.tfstate | jq -r '.resources[] | select(.type == "digitalocean_droplet") | .instances[] | select(.attributes.name == "leader1") | .attributes.ipv4_address'
