source .env
docker build --build-arg="DEBIAN_CODENAME=${DEBIAN_CODENAME}" --build-arg="DEV_CONTAINER_USER=${DEV_CONTAINER_USER}" -t pleandre/dev-container:latest .