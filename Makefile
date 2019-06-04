PROJECT=swarmon
DOCKER_USER=simonvadee
BASE_DOCKER_IMAGE=$(DOCKER_USER)/$(PROJECT)

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
	docker build -t $(DOCKER_IMAGE):latest -f $*/Dockerfile $*

# == publish ====================================================================
publish: $(PUBLISH_IMAGES)

SVC=$(word 2, $(subst /, ,$@))
DOCKER_IMAGE=$(BASE_DOCKER_IMAGE)-$(SVC)

$(PUBLISH_IMAGES): publish_docker_image_%: %/Dockerfile
	docker push $(DOCKER_IMAGE):latest

# == test ====================================================================
test:
	echo 'test'
