#!/bin/sh

set -x

echo 1. show rollout history
kubectl ${K8S_OPTS} rollout history deployments/${DOCKER_IMAGE_NAME}

echo 2. rollout undo
kubectl ${K8S_OPTS} rollout undo deployments/${DOCKER_IMAGE_NAME}

echo 3. rollout status
kubectl ${K8S_OPTS} rollout status deployments/${DOCKER_IMAGE_NAME}

echo 4. undo ok

