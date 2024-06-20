#!/bin/bash
set -e

# Install filebrowser
echo "> Installing filebrowser"
space_before=$(df --output=avail / --block-size=1 | tail -n 1)

curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

echo ">> Copying filebrowser startup scripts"
mkdir -p /opt/dev-container/filebrowser/
cp /scripts/tools/filebrowser/opt/* /opt/dev-container/filebrowser/

echo ">> Add filebrowser as a supervisord service"
echo "[program:filebrowser]
command=bash -c '/opt/dev-container/filebrowser/start-filebrowser.sh'
directory=/home/${DEV_CONTAINER_USER}/
user=root
autostart=true
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

" >> /etc/supervisor/conf.d/supervisord.conf

# Display install size
echo "- Installation completed: filebrowser"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / --block-size=1 | tail -n 1) )))"