# justfile

# Load environment variables from config.env
set dotenv-load := true
set dotenv-filename := "config.env"
set dotenv-required := true
set export := true
TIMESTAMP := `date '+%Y%m%d.%H%M'`

# Build container image
build:
    docker build \
        --build-arg BASE_IMAGE=${BASE_IMAGE} \
        --build-arg BASE_VERSION=${BASE_VERSION} \
        --build-arg USER_NAME=${USER_NAME} \
        --build-arg USER_UID=${USER_UID} \
        --build-arg USER_GID=${USER_GID} \
        --build-arg PIXI_VERSION=${PIXI_VERSION} \
        -f ${CONTAINERFILE} \
        -t ${DOCKER_USERNAME}/${DOCKER_IMAGE}:latest -t ${DOCKER_USERNAME}/${DOCKER_IMAGE}:${TIMESTAMP} .
    echo  "FROM ${DOCKER_USERNAME}/${DOCKER_IMAGE}:${TIMESTAMP}" > .devcontainer/${CONTAINERFILE}

bash:
    docker run -it ${DOCKER_USERNAME}/${DOCKER_IMAGE}:latest bash