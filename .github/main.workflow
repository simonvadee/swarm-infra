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
  needs = ["Filter"]
  uses = "docker://simonvadee/action-make-docker:latest"
  runs = "make"
  args = "publish"
}

action "Deploy" {
  needs = ["Publish"]
  uses = "docker://simonvadee/action-shell:latest"
  secrets = ["DO_AUTH_TOKEN", "DEPLOYMENT_KEY", "DEPLOYMENT_USER"]
  args = [
    "echo $DEPLOYMENT_KEY | base64 -d > id_rsa && chmod 400 id_rsa",
    "scp -o StrictHostKeyChecking=no -i id_rsa ./docker-compose.yml $DEPLOYMENT_USER@`ops/leader_host.sh`:/home/$DEPLOYMENT_USER/stack.yml",
    "scp -o StrictHostKeyChecking=no -i id_rsa ./traefik.toml $DEPLOYMENT_USER@`ops/leader_host.sh`:/home/$DEPLOYMENT_USER/traefik.toml",
    "ssh -o StrictHostKeyChecking=no -i id_rsa $DEPLOYMENT_USER@`ops/leader_host.sh` -o SendEnv=DO_AUTH_TOKEN -o SendEnv=GITHUB_SHA 'docker stack deploy -c stack.yml swarmon'"
  ]
}
