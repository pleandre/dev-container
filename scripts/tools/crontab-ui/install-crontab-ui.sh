#!/bin/bash
set -e

# Install crontab-ui
echo "> Installing crontab-ui"
space_before=$(df --output=avail / --block-size=1 | tail -n 1)

echo ">> Installing cron"
apt install -qq -y cron

echo ">> Installing crontab-ui"
su -l $DEV_CONTAINER_USER /bin/bash -c ". ~/.nvm/nvm.sh && npm install -g crontab-ui"

echo ">> Copying crontab-ui startup scripts"
mkdir -p /opt/dev-container/crontab-ui/
cp /scripts/tools/crontab-ui/opt/* /opt/dev-container/crontab-ui/

echo ">> Create crontab-ui log folder"
mkdir -p /var/log/crontab-ui
sudo chown -R ${DEV_CONTAINER_USER}:${DEV_CONTAINER_USER_GROUP} /var/log/crontab-ui
chmod -R 775 /var/log/crontab-ui

echo ">> Add Crontab UI as a supervisord service"
echo "[program:crontab-ui]
command=bash -c '/opt/dev-container/crontab-ui/start-crontab-ui.sh'
environment=HOME=\"/home/${DEV_CONTAINER_USER}\"
directory=/home/${DEV_CONTAINER_USER}/
user=dev-user
autostart=true
autorestart=true
stopwaitsecs=3
stopasgroup=true
killasgroup=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

" >> /etc/supervisor/conf.d/supervisord.conf

# Display install size
echo "- Installation completed: crontab-ui"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / --block-size=1 | tail -n 1) )))"