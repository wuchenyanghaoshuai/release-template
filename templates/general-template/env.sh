#!/usr/bin/env bash
# -*- encoding UTF-8 -*-
# Author: Johny

export DOCKER_IMAGE_NAME=general-template

# only set DOCKER_REGISTRY_URL if not set
[[ -z "$DOCKER_REGISTRY_URL" ]] && export DOCKER_REGISTRY_URL=192.168.100.36:1179/xiaoke

