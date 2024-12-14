#!/bin/bash
# set -euxo pipefail

# Load environment variables from config.env file
set -a
if [[ -f config.env ]]; then
  source config.env
fi

if [[ -f config.secrets ]]; then
  source config.env
fi
set +a


USER=${USERNAME:-atrawog}
LOCAL_UID=${LOCAL_UID:-1000}
LOCAL_GID=${LOCAL_GID:-1000}
LOCAL_DOCKER_GID=${LOCAL_DOCKER_GID:-954}

# Update UID/GID if necessary
if [ $(id -u $USER) -ne $LOCAL_UID ] || [ $(id -g $USER) -ne $LOCAL_GID ]; then
    echo "Updating $USER's UID to $LOCAL_UID and GID to $LOCAL_GID"
    
    # Modify group ID
    sudo groupmod -g $LOCAL_GID $USER
    
    # Modify user ID
    sudo usermod -u $LOCAL_UID -g $LOCAL_GID $USER
    
    # Fix ownership of home directory and workspace folder
    sudo chown -R $LOCAL_UID:$LOCAL_GID /home/$USER /workspace
fi

# Change docker group GID and set permissions on /var/run/docker.sock
if [ $(getent group docker | cut -d: -f3) -ne $LOCAL_DOCKER_GID ]; then
    echo "Changing docker group GID to $LOCAL_DOCKER_GID"
    sudo groupmod -g $LOCAL_DOCKER_GID docker
    sudo chown root:docker /var/run/docker.sock
fi

# Add user to docker group
sudo usermod -aG docker $USER

if ! pgrep -x supervisord > /dev/null; then
    echo "Starting supervisord..."
    sudo supervisord -c "/etc/supervisord.conf"
else
    echo "supervisord is already running."
fi

git config --global user.name $GIT_USERNAME
git config --global user.email $GIT_EMAIL


# Switch to non-root user and start bash or specified command
# exec sudo -u $USER -H "$@"
exec sudo -u $USER -H /usr/local/bin/pixi shell --no-install