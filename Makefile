IMAGE_NAME=unox
IMAGE_TAG=latest
IMAGE=$(IMAGE_NAME):$(IMAGE_TAG)
HOST=hal:5000
REMOTE_IMAGE=$(HOST)/$(IMAGE)

.PHONY: build
build:
	docker build -f ./dockerfiles/Dockerfile -t $(IMAGE) .

.PHONY: tag
tag:
	docker tag $(IMAGE) $(HOST)/$(IMAGE)

.PHONY: push
push:
	docker push $(REMOTE_IMAGE)

.PHONY: deploy
deploy: build tag push
