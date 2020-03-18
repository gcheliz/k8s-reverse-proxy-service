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

.PHONY : registry traefik build-docker push all

all: traefik build-docker push
	$(DEPLOY) $(ENVIRONMENT) $(NAMESPACE) $(DOCKER_REGISTRY) $(COMPONENTS)

build-docker:
	docker build -t $(IMAGE_TAG) ./nodejs-application

push:
	docker push $(IMAGE_TAG)

traefik:
	kubectl apply -f ./k8s/traefik/traefik.yaml

registry:
	docker run -d -p 5000:5000 --restart=always --name registry registry:2
