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
  secrets = ["DEPLOYMENT_KEY", "DEPLOYMENT_USER", "DEPLOYMENT_HOST"]
  args = [
    "echo $DEPLOYMENT_KEY | base64 -d > id_rsa && chmod 400 id_rsa",
    "scp -o StrictHostKeyChecking=no -v -i id_rsa ./docker-compose.yml $DEPLOYMENT_USER@$DEPLOYMENT_HOST:/home/$DEPLOYMENT_USER/stack.yml",
    "ssh -o StrictHostKeyChecking=no -i id_rsa $DEPLOYMENT_USER@$DEPLOYMENT_HOST 'docker stack deploy -c stack.yml swarmon'"
  ]
}
