workflow "Build and publish to DockerHub" {
  on = "push"
  resolves = ["Build services docker images"]
}

action "Docker Registry" {
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Shell" {
  needs = "Docker Registry"
  uses = "actions/bin/sh@master"
  args = ["ls -l"]
}

# action "Build" {
#   needs = "Shell"
#   uses = "actions/action-builder/shell@master"
#   runs = "make"
#   args = "build"
# }

action "Build services docker images" {
  needs = ["Shell"]
  uses = "./.github/build-docker-images/"
  args = "build"
}

# action "Publish services docker images" {
#   needs = "Build services docker images"
#   uses = "./.github/publish-docker-images/"
# }