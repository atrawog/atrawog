# justfile

set dotenv-load := true
set dotenv-filename := "config.env"
set dotenv-required := true
set export := true

# Define TIMESTAMP variable using backticks
TIMESTAMP := `date '+%Y%m%d.%H%M'`

# Pull container image to GitHub Container Registry
pull:
    docker pull ghcr.io/$DOCKER_USERNAME/$DOCKER_IMAGE-devel:latest && \
    docker pull  ghcr.io/$DOCKER_USERNAME/$DOCKER_IMAGE:latest


