workflow "Build and publish to DockerHub" {
  on = "push"
  resolves = ["Publish"]
}

action "Docker Registry" {
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Build" {
  needs = ["Docker Registry"]
  uses = "docker://simonvadee/action-docker-service:latest"
  runs = "make"
  args = "build"
}

action "Publish" {
  needs = ["Build"]
  uses = "docker://simonvadee/action-docker-service:latest"
  runs = "make"
  args = "publish"
}
