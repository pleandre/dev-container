#!/bin/bash

# To have a return code based on the success of all the commands
set -e
cd /scripts/

# Load .env file
cd /scripts/
source .env

# Set noninteractive for apt and update package list
export DEBIAN_FRONTEND=noninteractive
apt update -qq

# Create user and install common tools for a dev environment
./init/create-user.sh
./init/install-tools.sh
./init/setup-services.sh


# Install programming languages
./languages/dotnet-sdk/install-dotnet-sdk.sh
./languages/rust/install-rust.sh
./languages/node-js/install-node-js.sh
./languages/go/install-go.sh
./languages/c/install-c.sh
./languages/java/install-jdk.sh
./languages/python/install-python.sh
./languages/php/install-php.sh

# Install tools
./tools/docker/install-docker.sh
./tools/one-password/install-one-password.sh
./tools/cloud/install-cloud-tools.sh
./tools/code-server/install-code-server.sh
./tools/jupyter-lab/install-jupyter-lab.sh

# Clean after installs
apt clean
rm -rf /var/lib/apt/lists/*
