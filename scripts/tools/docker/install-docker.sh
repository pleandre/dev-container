#!/bin/bash
set -e

# Install docker
echo "> Installing docker"
space_before=$(df --output=avail / | tail -n 1)

apt install -y -qq \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg

# Install gpg keys
curl -fsSL "https://download.docker.com/linux/debian/gpg" | gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg

# Add docker release
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian ${DEBIAN_CODENAME} stable" > /etc/apt/sources.list.d/docker.list

# Install docker-ce-client
apt update -qq
apt install -y -qq docker-ce-cli

# Display install size
echo "- Installation completed: docker"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / | tail -n 1) )))"
