#!/bin/bash

set -a
source config.env
set +a

docker exec -it "${IMAGE_DEVEL}" bash -c "cd /workspace && pixi shell --no-install"