#!/bin/sh

set -x

echo 1. show rollout history
kubectl ${K8S_OPTS} --namespace ${K8S_NAME_SPACE} rollout history deployments/${K8S_DEPLOY_NAME}

echo 2. rollout undo
kubectl ${K8S_OPTS} --namespace ${K8S_NAME_SPACE} rollout undo deployments/${K8S_DEPLOY_NAME}

echo 3. rollout status
kubectl ${K8S_OPTS} --namespace ${K8S_NAME_SPACE} rollout status deployments/${K8S_DEPLOY_NAME}

echo 4. undo ok

