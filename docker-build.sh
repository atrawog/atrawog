#!/bin/bash

set -a
source config.env
set +a

TIMESTAMP=$(date '+%Y%m%d.%H%M')
IMAGE_NAME=${DOCKER_USERNAME}/${IMAGE_DEVEL}

./docker-prune.sh

echo  "FROM ${IMAGE_NAME}:${TIMESTAMP}" > .devcontainer/Dockerfile 

# Build the Docker image and tag it with 'latest' and the current timestamp
docker build \
    --build-arg BASE_IMAGE=${BASE_IMAGE} \
    --build-arg BASE_VERSION=${BASE_VERSION} \
    --build-arg USERNAME=${USERNAME} \
    --build-arg USER_UID=${USER_UID} \
    --build-arg USER_GID=${USER_GID} \
    --build-arg PIXI_VERSION=${PIXI_VERSION} \
    --build-arg ARCH_BASE="${ARCH_BASE}" \
    --build-arg ARCH_AI="${ARCH_AI}" \
    --build-arg ARCH_EXTRA="${ARCH_EXTRA}" \
    --build-arg ARCH_TESTING="${ARCH_TESTING}" \
    -f Dockerfile.devel \
    -t ${IMAGE_NAME}:latest -t ${IMAGE_NAME}:${TIMESTAMP} .