#!/bin/sh

# Set the DOCKER_BUILDKIT environment variable
export DOCKER_BUILDKIT=1

# Build the Docker image
docker build -t update-version -f update-versions.Dockerfile .

# Run the Docker container with the mounted volumes
docker run \
  -v "$(pwd)"/.env:/workspace/.env \
  -v "$(pwd)"/scripts/tools/jupyter-lab/:/workspace/scripts/tools/jupyter-lab/ \
  -v "$(pwd)"/.github/workflows/update-versions.py:/workspace/update-versions.py \
  update-version
