#!/bin/bash
# set -euxo pipefail
# set -x

cd /workspace

# Load environment variables from config.env file
set -a
if [[ -f /workspace/config.env ]]; then
  source /workspace/config.env
  LIBVIRT_DEFAULT_URI="qemu+ssh://${USER_NAME}@${LIBVIRT_HOST}/system"
fi
set +a

/usr/local/bin/fixpermission.sh
/usr/local/bin/setpassword.sh
sudo /usr/sbin/supervisord -c /etc/supervisord.conf > /dev/null 2>&1 &
exec sudo -u $USER_NAME -H /usr/local/bin/pixi shell --no-install
