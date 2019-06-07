DOCKER_PROJECT=swarmon
DOCKER_USER=simonvadee
BASE_DOCKER_IMAGE=$(DOCKER_USER)/$(DOCKER_PROJECT)
GITHUB_SHA?=latest
DOCKER_TAG=$(GITHUB_SHA)

SERVICES=$(shell ls -d services/*)
BUILD_IMAGES=$(foreach service, $(SERVICES), build_docker_image_$(service))
PUBLISH_IMAGES=$(foreach service, $(SERVICES), publish_docker_image_$(service))


# == all ======================================================================
all: build

# == build ====================================================================
build: $(BUILD_IMAGES)

SVC=$(word 2, $(subst /, ,$@))
DOCKER_IMAGE=$(BASE_DOCKER_IMAGE)-$(SVC)

$(BUILD_IMAGES): build_docker_image_%: %/Dockerfile
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) -f $*/Dockerfile $*

# == publish ====================================================================
publish: $(PUBLISH_IMAGES)

SVC=$(word 2, $(subst /, ,$@))
DOCKER_IMAGE=$(BASE_DOCKER_IMAGE)-$(SVC)

$(PUBLISH_IMAGES): publish_docker_image_%: %/Dockerfile
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)


# == provision ====================================================================
provision:
	terraform apply \
		-var "do_token=${DIGITALOCEAN_ACCESS_TOKEN}" \
		-var "ssh_key=${DIGITALOCEAN_SSH_KEY_PATH}" \
		-var "ssh_user=${DIGITALOCEAN_SSH_USER}" \
		-var "ssh_fingerprint=${DIGITALOCEAN_SSH_KEY_FINGERPRINT}" \
		-var "ci_ssh_fingerprint=${DIGITALOCEAN_CI_SSH_KEY_FINGERPRINT}" \
		-state ops/cluster.tfstate ops

# == destroy ====================================================================
destroy:
	terraform destroy \
		-var "do_token=${DIGITALOCEAN_ACCESS_TOKEN}" \
		-var "ssh_key=${DIGITALOCEAN_SSH_KEY_PATH}" \
		-var "ssh_user=${DIGITALOCEAN_SSH_USER}" \
		-var "ssh_fingerprint=${DIGITALOCEAN_SSH_KEY_FINGERPRINT}" \
		-var "ci_ssh_fingerprint=${DIGITALOCEAN_CI_SSH_KEY_FINGERPRINT}" \
		-state ops/cluster.tfstate ops