#!/bin/bash
set -e

# Install webmin
echo "> Installing webmin"
space_before=$(df --output=avail / --block-size=1 | tail -n 1)

echo ">> Adding webmin repository"
curl -fsSL "https://download.webmin.com/developers-key.asc" | gpg --dearmor --yes -o /etc/apt/keyrings/debian-webmin-developers.gpg
echo "deb [signed-by=/etc/apt/keyrings/debian-webmin-developers.gpg] https://download.webmin.com/download/newkey/repository stable contrib" > /etc/apt/sources.list.d/webmin.list
apt update -qq

echo ">> Installing webmin"
apt install -qq -y webmin net-tools

echo ">> Copying webmin startup scripts"
mkdir -p /opt/dev-container/webmin/
cp /scripts/tools/webmin/opt/* /opt/dev-container/webmin/

# Setup service
echo ">> Creating Webmin service config in Supervisord"

echo "[program:webmin]
command=bash -c '/opt/dev-container/webmin/webmin-start.sh'
directory=/home/
user=root
autostart=true
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

" >> /etc/supervisor/conf.d/supervisord.conf


# Display install size
echo "- Installation completed: webmin"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / --block-size=1 | tail -n 1) )))"