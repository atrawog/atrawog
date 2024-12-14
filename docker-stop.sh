#!/bin/bash

set -a
source config.env
set +a

docker stop $IMAGE_DEVEL
docker rm $IMAGE_DEVEL