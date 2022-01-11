#!/bin/sh

set -x
set -o errexit

# docker build push
docker_name="${DOCKER_REGISTRY_URL}/${DOCKER_NAME_SPACE}/${DOCKER_IMAGE_NAME}:${DOCKER_TAG}"

echo "docker_name:${docker_name}"

docker ${DOCKER_OPTS} build --force-rm=true --no-cache=true  -t ${docker_name} ${DOCKER_FILE}

docker ${DOCKER_OPTS} push ${docker_name}

