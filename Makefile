DOCKER_REGISTRY=simonvadee/swarmon

SERVICES=$(shell ls -d services/*)
IMAGES=$(foreach service, $(SERVICES), $(DOCKER_REGISTRY)-$(word 2, $(subst /, ,$(service))))

# == all ======================================================================
all: build

# == build ====================================================================
build: $(SERVICES)

SVC=$(word 2, $(subst /, ,$@))

$(SERVICES): $(SERVICES)/Dockerfile
	docker build -t $(DOCKER_REGISTRY)-$(SVC) -f $@/Dockerfile $@

# == publish ====================================================================
publish: $(IMAGES)

$(IMAGES): %:
	docker push $@:latest

# == deploy ====================================================================
deploy: $(IMAGES)

$(IMAGES): %:
	docker push $@:latest
