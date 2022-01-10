#!/bin/sh

set -x

PGRDIR=$(cd `dirname $0`; pwd)
source ${PGRDIR}/../env.sh


kubectl ${K8S_OPTS} --namespace=${K8S_NAME_SPACE} rollout history deployments/$DOCKER_IMAGE_NAME
kubectl ${K8S_OPTS} --namespace=${K8S_NAME_SPACE} rollout undo deployments/$DOCKER_IMAGE_NAME
kubectl ${K8S_OPTS} --namespace=${K8S_NAME_SPACE} rollout status deployments/$DOCKER_IMAGE_NAME

