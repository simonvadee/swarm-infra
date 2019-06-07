workflow "Build, publish to DockerHub and deploy to Docker Swarm cluster" {
  on = "push"
  resolves = ["Deploy"]
}

action "Docker Registry" {
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Build" {
  needs = ["Docker Registry"]
  uses = "docker://simonvadee/action-make-docker:latest"
  runs = "make"
  args = "build"
}

action "Filter" {
  needs = ["Build"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Publish" {
  needs = ["Build"]
  uses = "docker://simonvadee/action-make-docker:latest"
  runs = "make"
  args = "publish"
}

action "Deploy" {
  # needs = ["Publish"]
  uses = "docker://simonvadee/action-shell:latest"
  secrets = ["DO_AUTH_TOKEN", "DEPLOYMENT_KEY", "DEPLOYMENT_USER"]
  env = {
    TEST = "`cat ops/cluster.tfstate | jq -r '.resources[] | select(.type == \"digitalocean_droplet\") | .instances[] | select(.attributes.name == \"leader1\") | .attributes.ipv4_address'`"
  }
  args = [
    ". ops/configure_ci.sh",
    "cat ops/cluster.tfstate | jq -r '.resources[] | select(.type == \"digitalocean_droplet\") | .instances[] | select(.attributes.name == \"leader1\") | .attributes.ipv4_address'",
    "export DEPLOYMENT_HOST=`cat ops/cluster.tfstate | jq -r '.resources[] | select(.type == \"digitalocean_droplet\") | .instances[] | select(.attributes.name == \"leader1\") | .attributes.ipv4_address'`",
    "env",
    "scp -o StrictHostKeyChecking=no -v -i id_rsa ./docker-compose.yml $DEPLOYMENT_USER@$DEPLOYMENT_HOST:/home/$DEPLOYMENT_USER/stack.yml",
    "scp -o StrictHostKeyChecking=no -v -i id_rsa ./traefik.toml $DEPLOYMENT_USER@$DEPLOYMENT_HOST:/home/$DEPLOYMENT_USER/traefik.toml",
    "ssh -o StrictHostKeyChecking=no -i id_rsa $DEPLOYMENT_USER@$DEPLOYMENT_HOST -o SendEnv=DO_AUTH_TOKEN 'stack deploy -c stack.yml swarmon'"
  ]
}
