#!/bin/bash

set -a
source config.env
set +a

# Get the IMAGE ID of the latest image
IMAGE_NAME=${DOCKER_USERNAME}/${IMAGE_DEVEL}
TARGET_IMAGE_ID=$(docker images --format "{{.ID}}" ${IMAGE_NAME}:latest )


# Check if the IMAGE ID was found
if [ -z "$TARGET_IMAGE_ID" ]; then
  echo "Error: Could not find IMAGE ID for ${IMAGE_NAME}:latest"
  exit 1
fi

echo "Target IMAGE ID: $TARGET_IMAGE_ID"

# Find all images with the same IMAGE ID and push them
docker images --format "{{.Repository}}:{{.Tag}} {{.ID}}" | grep "$TARGET_IMAGE_ID" | while read -r line; do
  IMAGE=$(echo "$line" | awk '{print $1}') # Extract the REPOSITORY:TAG
  echo "Pushing $IMAGE to Docker Hub..."
  docker push "$IMAGE"
done

echo "All matching images have been pushed."
