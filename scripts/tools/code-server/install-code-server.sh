#!/bin/bash
set -e

# Install Code Server
echo "> Installing code-server"
space_before=$(df --output=avail / --block-size=1 | tail -n 1)

echo ">> Copying code-server environment variables and startup scripts"
mkdir -p /opt/dev-container/code-server/
cp /scripts/tools/code-server/opt/* /opt/dev-container/code-server/
cp /scripts/tools/code-server/code-server-env.sh /etc/profile.d/code-server-env.sh

mkdir -p /opt/dev-container/code-server/data/
touch /opt/dev-container/code-server/data/installed-extensions.txt
source /etc/profile

echo ">> Set /opt/dev-container/code-server/ access rights"
chown -R ${DEV_CONTAINER_USER}:${DEV_CONTAINER_USER_GROUP} /opt/dev-container/code-server/
find /opt/dev-container/code-server/ -type d -exec chmod u+rwx,g+rwx,o+rx '{}' \;
find /opt/dev-container/code-server/ -type f -exec chmod u+rw,g+rw,o+r '{}' \;

mkdir -p /home/${DEV_CONTAINER_USER}/projects

echo ">> Installing code-server"
curl -fsSL https://code-server.dev/install.sh | sh -s -- --version $CODE_SERVER_VERSION

# Setup service
echo ">> Creating code-server service config"
echo "[program:code-server]
environment=HOME=\"/home/${DEV_CONTAINER_USER}\"
command=bash -c '/opt/dev-container/code-server/code-server-start.sh'
directory=/home/${DEV_CONTAINER_USER}/projects
user=${DEV_CONTAINER_USER}
autostart=true
autorestart=true
stopwaitsecs=3
stopasgroup=true
killasgroup=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

" >> /etc/supervisor/conf.d/supervisord.conf

# Set access
mkdir -p /home/${DEV_CONTAINER_USER}/.local/share/code-server
sudo chown -R ${DEV_CONTAINER_USER}:${DEV_CONTAINER_USER_GROUP} /home/${DEV_CONTAINER_USER}/.local
sudo chown -R ${DEV_CONTAINER_USER}:${DEV_CONTAINER_USER_GROUP} /opt/dev-container/
find /home/${DEV_CONTAINER_USER}/.local/share/code-server -type d -exec chmod u+rwx,g+rwx,o+rx '{}' \;
find /home/${DEV_CONTAINER_USER}/.local/share/code-server -type f -exec chmod u+rw,g+rw,o+r '{}' \;
find /opt/dev-container/ -type d -exec chmod u+rwx,g+rwx,o+rx '{}' \;
find /opt/dev-container/ -type f -exec chmod u+rw,g+rw,o+r '{}' \;

# Disable git safe directory check (to be able to mount git repos from host)
git config --global --add safe.directory '*'

# Display install size
echo "- Installation completed: code server"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / --block-size=1 | tail -n 1) )))"
