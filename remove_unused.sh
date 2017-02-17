#!/bin/bash
set -e

# Script to remove all docker images that are not used by a docker container

# Remove dangling images
docker rmi $(docker images -q -f dangling=true) 2>/dev/null || echo "No dangling images"

# Store all images and containers in separate arrays
IMAGES=($(docker images | tail -n +2 | awk '{print $1":"$2}'))
CONTAINERS=($(docker ps -a | tail -n +2 | awk '{print $2}'))

# If "docker ps" returns containers that do not have a tag, e.g. prismfp/python2 rather than prismfp/python2:<tag>,
# then the container implicitly uses the "latest" tag. This loop adds "latest" to the images where this is the case
for i in ${!CONTAINERS[@]}; do
    if [[ ! ${CONTAINERS[$i]} =~ ":" ]]; then
        CONTAINERS[$i]=${CONTAINERS[$i]}:latest
    fi
done

# Remove all images that are not currently used by a container
for i in ${IMAGES[@]}; do
    if [[ ! ${CONTAINERS[*]} =~ $i ]]; then
        docker rmi $i
    fi
done
