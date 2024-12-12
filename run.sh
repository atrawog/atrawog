#!/bin/bash

# Define variables
IMAGE_NAME="atrawog/atrawog:latest"

# Ensure SSH_AUTH_SOCK is set
if [ -z "$SSH_AUTH_SOCK" ]; then
  echo "Error: SSH_AUTH_SOCK is not set. Please ensure your SSH agent is running."
  exit 1
fi

# Run the Docker container with the specified mounts
docker run -it --rm \
  -e SSH_AUTH_SOCK=/ssh-agent \
  -v "$SSH_AUTH_SOCK":/ssh-agent \
  -v "$(pwd)":/workspace \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /dev/kvm:/dev/kvm \
  "$IMAGE_NAME"
