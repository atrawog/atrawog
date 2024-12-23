#!/bin/bash
# set -euxo pipefail
# set -x

# Load environment variables from config.env file
set -a
if [[ -f config.env ]]; then
  source config.env
fi

USERNAME=${USERNAME:-atrawog}
LOCAL_UID=${LOCAL_UID:-1000}
LOCAL_GID=${LOCAL_GID:-1000}
LOCAL_DOCKER_GID=${LOCAL_DOCKER_GID:-954}

# Update UID/GID if necessary
if [ $(id -u $USERNAME) -ne $LOCAL_UID ] || [ $(id -g $USERNAME) -ne $LOCAL_GID ]; then
    echo "Updating $USERNAME's UID to $LOCAL_UID and GID to $LOCAL_GID"
    
    # Modify group ID
    sudo groupmod -g $LOCAL_GID $USERNAME
    
    # Modify user ID
    sudo usermod -u $LOCAL_UID -g $LOCAL_GID $USERNAME
    
    # Fix ownership of home directory and workspace folder
    sudo chown -R $LOCAL_UID:$LOCAL_GID /home/$USERNAME
fi

# Change docker group GID and set permissions on /var/run/docker.sock
if [ $(getent group docker | cut -d: -f3) -ne $LOCAL_DOCKER_GID ]; then
    echo "Changing docker group GID to $LOCAL_DOCKER_GID"
    sudo groupmod -g $LOCAL_DOCKER_GID docker
    sudo chown root:docker /var/run/docker.sock
fi

# Add user to docker group
sudo usermod -aG docker $USERNAME