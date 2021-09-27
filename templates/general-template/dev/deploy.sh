#!/bin/bash

############################################################
# prepare
############################################################
export PGRDIR=$(cd `dirname $0`; pwd)
WORKSPACE=${PGRDIR}/../
export VERSION=$1
source ${WORKSPACE}/env.sh

# only set VERSION if not set
[[ -z "$VERSION" ]] && VERSION=latest
[[ -z "$K8S_OPTS" ]] && K8S_OPTS="-s 192.168.100.36:1179 --namespace=kkb-xk-test"


############################################################
# doing
############################################################


echo 1. delete: kubectl ${K8S_OPTS} delete deployment ${DOCKER_IMAGE_NAME}
kubectl ${K8S_OPTS} delete deployment ${DOCKER_IMAGE_NAME}

echo 2. deploy: kubectl ${K8S_OPTS} apply -f ${PGRDIR}/k8s/deploy.yml
kubectl ${K8S_OPTS} apply -f ${PGRDIR}/k8s/deploy.yml

echo 3. deploy: kubectl ${K8S_OPTS} apply -f ${PGRDIR}/k8s/svc.yml
kubectl ${K8S_OPTS} apply -f ${PGRDIR}/k8s/svc.yml

echo 4. show status
kubectl ${K8S_OPTS} get pod | grep ${DOCKER_IMAGE_NAME}