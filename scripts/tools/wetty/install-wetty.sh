#!/bin/bash
set -e

# Install wetty
echo "> Installing wetty"
space_before=$(df --output=avail / | tail -n 1)

echo ">> Installing wetty"
su -l $DEV_CONTAINER_USER /bin/bash -c ". ~/.nvm/nvm.sh && npm install -g wetty"

echo ">> Copying wetty startup scripts"
mkdir -p /opt/dev-container/wetty/
cp /scripts/tools/wetty/opt/* /opt/dev-container/wetty/

echo ">> Add wetty as a supervisord service"
echo "[program:wetty-web-shell]
command=bash -c '/opt/dev-container/wetty/start-wetty.sh'
directory=/home/${DEV_CONTAINER_USER}/
user=dev-user
autostart=true
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

" >> /etc/supervisor/conf.d/supervisord.conf

# Display install size
echo "- Installation completed: wetty"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / | tail -n 1) )))"