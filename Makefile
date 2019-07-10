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
provision_do:
	terraform apply \
		-var "do_token=${DIGITALOCEAN_ACCESS_TOKEN}" \
		-var "cloudflare_token=${CLOUDFLARE_ACCESS_TOKEN}" \
		-state ops/cluster.tfstate ops/digitalocean

provision_sw:
	terraform apply \
		-var "sw_token=${SCALEWAY_TOKEN}" \
		-var "sw_org_id=${SCALEWAY_ORGANISATION_ID}" \
		-var "cloudflare_token=${CLOUDFLARE_ACCESS_TOKEN}" \
		-state ops/cluster.tfstate ops/scaleway

# == destroy ====================================================================
destroy_do:
	terraform destroy \
		-var "do_token=${DIGITALOCEAN_ACCESS_TOKEN}" \
		-var "cloudflare_token=${CLOUDFLARE_ACCESS_TOKEN}" \
		-state ops/cluster.tfstate ops/digitalocean

destroy_sw:
	terraform destroy \
		-var "sw_token=${SCALEWAY_TOKEN}" \
		-var "sw_org_id=${SCALEWAY_ORGANISATION_ID}" \
		-var "cloudflare_token=${CLOUDFLARE_ACCESS_TOKEN}" \
		-state ops/cluster.tfstate ops/scaleway

# == connect ====================================================================
connect:
	ssh rancher@`./ops/leader_host.sh`