#!/bin/sh

set -x

STR1="s/{{build_image_tag}}/${DOCKER_TAG}/g" && sed -i ${STR1} ${K8S_DEPLOY_YML} && cat ${K8S_DEPLOY_YML}

echo 1. show rollout history
kubectl ${K8S_OPTS}  --namespace=${K8S_NAME_SPACE}  apply -f ${K8S_DEPLOY_YML} --record

echo 2. trigger rollout
kubectl ${K8S_OPTS}  --namespace=${K8S_NAME_SPACE}  apply -f ${K8S_SVC_YML} --record

echo 3. show rollout status
kubectl ${K8S_OPTS}  --namespace=${K8S_NAME_SPACE} rollout status deployments/${K8S_DEPLOY_NAME}

echo deploy ok

