#!/bin/bash

# Setup supervisord config (for services running)
# We also include a file which can be used to configure supervisord webserver on startup
# File will be empty if it's disabled or will contain config if it's enabled
echo "> Setup supervisord config (for services running)"
echo "[supervisord]
nodaemon=true
user=root
pidfile=/var/run/supervisord.pid
logfile=/dev/null
logfile_maxbytes=0

[include]
files = /etc/supervisor/conf.d/supervisord-web.conf

" > /etc/supervisor/conf.d/supervisord.conf

touch /etc/supervisor/conf.d/supervisord-web.conf

echo "- Installation completed: supervisord.conf"