#!/bin/bash

# Function to change the GID of the docker group
change_docker_group_gid() {
    local docker_sock_gid=$(stat -c '%g' /var/run/docker.sock)
    local current_docker_gid=$(getent group docker | cut -d: -f3)

    if [ "$docker_sock_gid" != "$current_docker_gid" ]; then
        echo "Changing docker group GID to $docker_sock_gid"
        sudo groupmod -g $docker_sock_gid docker
        sudo chown root:docker /var/run/docker.sock
    else
        echo "Docker group GID already matches the GID of /var/run/docker.sock"
    fi
}

# Function to add the current user to the docker group
add_user_to_docker_group() {
    local user=${USER:-jovyan}
    echo "Adding user $user to the docker group"
    sudo usermod -aG docker $user
}


# Run pixi install if .pixi directory is not present
if [ ! -d ".pixi" ]; then
    echo "Running pixi install --frozen"
    pixi install --frozen
fi

# Change the GID of the docker group
change_docker_group_gid

# Add the current user to the docker group
add_user_to_docker_group

# Re-execute the shell with the new group memberships
exec sg docker newgrp $(id -gn)