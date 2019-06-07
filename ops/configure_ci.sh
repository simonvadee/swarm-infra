export DEPLOYMENT_HOST=`cat ops/cluster.tfstate | jq -r '.resources[] | select(.type == "digitalocean_droplet") | .instances[] | select(.attributes.name == "leader1") | .attributes.ipv4_address'`

echo $DEPLOYMENT_KEY | base64 -d > id_rsa && chmod 400 id_rsa