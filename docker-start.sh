#!/bin/bash

set -a
source config.env
set +a

# Define variables
IMAGE_NAME=${DOCKER_USERNAME}/${IMAGE_DEVEL}:latest

# Ensure SSH_AUTH_SOCK is set
if [ -z "$SSH_AUTH_SOCK" ]; then
  echo "Error: SSH_AUTH_SOCK is not set. Please ensure your SSH agent is running."
  exit 1
fi

FILE="jupyterhub_cookie.secret"
if [ -e "$FILE" ]; then
    echo "The file $FILE already exists. No new cookie_secret was generated."
else
    echo "Generating a new JupyterHub cookie_secret..."
    openssl rand -hex 32 | tee "$FILE"
    chmod 600 "$FILE"
    echo "New cookie_secret saved to $FILE."
fi

# Run the Docker container with the specified mounts
docker run -d \
  --restart ${DOCKER_RESTART} \
  -p 8000:8000 \
  -p 8888:8888 \
  -e SSH_AUTH_SOCK=/ssh-agent \
  -v "$SSH_AUTH_SOCK":/ssh-agent \
  -v "$(pwd)":/workspace \
  -v "/media":/media \
  -v "/sync":/sync \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /dev/kvm:/dev/kvm \
  --name ${IMAGE_DEVEL} \
  "$IMAGE_NAME"