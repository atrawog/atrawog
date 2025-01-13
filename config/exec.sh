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
/usr/local/bin/setpassword.sh
sudo /usr/sbin/supervisord -c /etc/supervisord.conf > /dev/null 2>&1 &
exec sudo -u $USER_NAME -H /usr/local/bin/pixi shell --no-install
