#!/bin/bash
# set -euxo pipefail
# set -x

# Load environment variables from config.env file
set -a
if [[ -f config.env ]]; then
  source config.env
fi

cd /workspace
/usr/local/bin/fixpermission.sh
exec sudo -u $USERNAME -H /usr/local/bin/pixi shell --no-install
