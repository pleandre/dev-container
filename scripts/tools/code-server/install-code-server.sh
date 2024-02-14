#!/bin/bash
set -e

# Install Code Server
echo "> Installing code-server"
space_before=$(df --output=avail / | tail -n 1)

curl -fsSL https://code-server.dev/install.sh | sh -s -- --version $CODE_SERVER_VERSION

# Setup service
echo ">> Creating code-server service config"
echo "[program:code-server]
environment=HOME=\"/home/${DEV_CONTAINER_USER}\"
command=bash -c 'source /etc/profile && exec code-server --auth none --bind-addr 0.0.0.0:8080'
directory=/home/${DEV_CONTAINER_USER}/
user=${DEV_CONTAINER_USER}
autostart=true
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

" >> /etc/supervisor/conf.d/supervisord.conf

# Display install size
echo "- Installation completed: code server"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / | tail -n 1) )))"
