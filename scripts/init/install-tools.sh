#!/bin/bash
set -e

# Install common tools for a dev environment
echo "> Installing common tools for a dev environment"
space_before=$(df --output=avail / --block-size=1 | tail -n 1)

apt install -y -qq dos2unix \
	git \
	git-lfs \
	cron \
	curl \
	wget \
	vim \
	nano \
	htop \
	man-db \
	apache2-utils \
	openssh-client \
	tree \
	openssl \
	jq \
	ncdu \
	httpie \
	unzip \
	tar \
	zip \
	supervisor \
	grep \
	gzip \
	procps \
	sudo \
	ca-certificates \
	net-tools \
	zsh \
	lsb-release 

# Install git Large File System
git lfs install

# Display install size
echo "- Installation completed: common tools"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / --block-size=1 | tail -n 1) )))"