#!/bin/bash
set -e

# Script to remove all docker containers and then only keep the most recent docker images

# Stop running containers
docker stop $(docker ps -aq) 2>/dev/null || echo "No running containers"

# Remove all stopped containers
docker rm $(docker ps -aq) 2>/dev/null || echo "No stopped containers"

# Remove dangling images
docker rmi $(docker images -q -f dangling=true) 2>/dev/null || echo "No dangling images"

# Find all unique image names
for i in $(docker images -f {{.Repository}} | uniq); do
    # Remove all tagged images other than the latest
    LATEST_IMAGE=$(docker images -q $i | head -n 1)
    docker rmi $(docker images -q -f before=$LATEST_IMAGE $i) 2>/dev/null || echo "No old images need removing for $i"
done
