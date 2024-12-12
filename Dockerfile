# Use Arch Linux as base image
FROM archlinux:latest

# Arguments for default UID/GID and username
ARG USERNAME=jovyan
ARG USER_UID=1000
ARG USER_GID=1000

# Set environment variables for the user
ENV USERNAME=${USERNAME}
ENV HOME=/home/${USERNAME}

# Install base development tools, sudo, pixi, and other dependencies
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm base-devel git vim sudo opentofu iotop htop openssh curl \
    libvirt wget sysstat docker docker-buildx docker-compose qemu-base iproute2 \
    cuda cudnn gocryptfs sshfs fuse3 linux linux-headers minikube pixi supervisor && \
    groupadd --gid ${USER_GID} ${USERNAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR ${HOME}

# Install yay (AUR helper)
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm && \
    cd .. && rm -rf yay

RUN mkdir -p ${HOME}/.config/libvirt && \
    echo 'uri_default = "qemu:///system"' | tee ${HOME}/.config/libvirt/libvirt.conf

# Enable Pixi autocompletion
RUN echo 'eval "$(pixi completion --shell bash)"' >> ${HOME}/.bashrc

# Switch back to root to copy and set permissions on entrypoint script
USER root

# Copy entrypoint script and set executable permissions
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN mkdir -p /{media,sync,workspace} && \
    chown -R ${USERNAME}:${USERNAME} /{media,sync,workspace}
# Set working directory and entrypoint script
WORKDIR /workspace

# Set entrypoint and default command
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["pixi", "shell", "--no-install"]
EXPOSE 8888
USER ${USERNAME}
