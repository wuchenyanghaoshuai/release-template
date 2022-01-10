#!/bin/bash

PGRDIR=$(cd `dirname $0`; pwd)

WORKSPACE=$PGRDIR/../

VERSION=base

source $PGRDIR/env.sh

set -e

cat $WORKSPACE/release/DockerfileBase

docker build -t $DOCKER_REGISTRY_URL/$DOCKER_NAME_SPACE/$DOCKER_IMAGE_NAME:$VERSION -f $WORKSPACE/release/DockerfileBase $WORKSPACE
