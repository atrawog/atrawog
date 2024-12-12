#!/bin/bash

# Define variables
IMAGE_NAME="atrawog/atrawog"
TIMESTAMP=$(date '+%Y%m%d%H%M')

# Build the Docker image and tag it with 'latest' and the current timestamp
docker build -t ${IMAGE_NAME}:latest -t ${IMAGE_NAME}:${TIMESTAMP} .