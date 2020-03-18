DOCKER_REGISTRY?=localhost:5000
NAMESPACE?=demo
TAG?=latest
PROJECT?=demo/api
IMAGE=$(DOCKER_REGISTRY)/$(PROJECT)
IMAGE_TAG=$(IMAGE):$(TAG)
MAIN_BRANCH?=master
ENVIRONMENT?=integration
DEPLOY?=./deploy.sh
COMPONENTS ?= api:$(TAG)

all:
	$(DEPLOY) $(ENVIRONMENT) $(NAMESPACE) $(DOCKER_REGISTRY) $(COMPONENTS)

build-docker:
	docker build -t $(IMAGE_TAG) ./nodejs-application

push:
	docker push $(IMAGE_TAG)

