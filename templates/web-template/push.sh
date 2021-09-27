#!/usr/bin/env bash

PGRDIR=$(cd `dirname $0`; pwd)
VERSION=$1

source $PGRDIR/env.sh

# break shell when fail
set -e

# only set VERSION if not set
[ -z "$VERSION" ] && VERSION=latest

echo upload image $VERSION
docker push $DOCKER_REGISTRY_URL/$DOCKER_NAME_SPACE/$DOCKER_IMAGE_NAME:$VERSION
