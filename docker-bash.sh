#!/bin/bash

set -a
source config.env
set +a

docker exec -it "${IMAGE_DEVEL}" bash -c "source /etc/profile; cd /workspace; bash"