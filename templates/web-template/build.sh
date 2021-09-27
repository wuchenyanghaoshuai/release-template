#!/bin/bash

PGRDIR=$(cd `dirname $0`; pwd)
WORKSPACE=$PGRDIR/../
RELEASE_ENV=$1
VERSION=$2

source $PGRDIR/env.sh

set -e


[[ -z "$RELEASE_ENV" ]] && RELEASE_ENV=prod

sed -i "s/RUN npm run build:.*/RUN npm run build:$RELEASE_ENV/g" $WORKSPACE/release/Dockerfile

cat $WORKSPACE/release/Dockerfile
cp $WORKSPACE/release/nginx.default.conf $WORKSPACE
docker build -t $DOCKER_REGISTRY_URL/$DOCKER_NAME_SPACE/$DOCKER_IMAGE_NAME:$VERSION -f $WORKSPACE/release/Dockerfile $WORKSPACE
