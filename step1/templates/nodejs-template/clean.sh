#!/bin/bash
set -e

IMAGE_NAME=$1
# weeks months years
for image in `docker image ls|grep ${IMAGE_NAME}|grep -v base|grep -E 'years ago|months ago|weeks ago'|awk '{print $3}'`
do
    docker rmi -f $image
done

# hours days
for image_day in `docker image ls|grep ${IMAGE_NAME}|grep -v base|grep 'days ago'|awk '{print $3"==="$4}'`
do
    image=`echo ${image_day} |sed 's/===.*//g'`
    day=`echo ${image_day}|sed 's/.*===//g'`
    if [ $day -gt 7 ]
    then 
        docker rmi -f $image
    fi
done
