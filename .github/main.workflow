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

# Filter for master branch
action "Filter" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Publish" {
  needs = ["Filter"]
  uses = "docker://simonvadee/action-docker-service:latest"
  runs = "make"
  args = "publish"
}
