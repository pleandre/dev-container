#!/bin/bash
set -e

# Install common tools for a dev environment
echo "> Installing common tools for a dev environment"
space_before=$(df --output=avail / | tail -n 1)

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
	unzip \
	supervisor \
	grep \
	gzip \
	cron \
	procps \
	sudo \
	ca-certificates \
	zsh \
	lsb-release 

# Install git Large File System
git lfs install

# Setup supervisord config (for services running)
echo "[supervisord]
nodaemon=true
user=root
pidfile=/var/run/supervisord.pid
logfile=/dev/null
logfile_maxbytes=0

" > /etc/supervisor/conf.d/supervisord.conf

# Display install size
echo "- Installation completed: common tools"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / | tail -n 1) )))"