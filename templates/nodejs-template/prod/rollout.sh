#!/bin/sh

set -x

PGRDIR=$(cd `dirname $0`; pwd)
source ${PGRDIR}/../env.sh
STR1="s/{{VERSION}}/${DOCKER_TAG}/g" && sed -i ${STR1} ${K8S_DEPLOY_YML} && cat ${K8S_DEPLOY_YML}


kubectl ${K8S_OPTS}  --namespace=${K8S_NAME_SPACE} --validate=false apply -f ${K8S_SVC_YML} --record

kubectl ${K8S_OPTS}  --namespace=${K8S_NAME_SPACE} --validate=false apply -f ${K8S_DEPLOY_YML} --record


kubectl ${K8S_OPTS} --namespace=${K8S_NAME_SPACE} rollout status deployments/$DOCKER_IMAGE_NAME
