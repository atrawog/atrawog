#!/bin/bash
# set -euxo pipefail
# set -x

# Load environment variables from config.env file
set -a
if [[ -f config.env ]]; then
  source config.env
fi

USERNAME=${USERNAME:-atrawog}

# Set the password for the user

if [ -n "$PASSWORD" ]; then
    echo "Setting password for $USERNAME"
    echo "$USERNAME:$PASSWORD" | chpasswd -e
fi