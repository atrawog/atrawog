#!/bin/bash

set -a
source config.env
set +a

docker exec -it "${IMAGE_DEVEL}" bash -c "sudo /usr/local/bin/exec.sh"