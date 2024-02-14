#!/bin/bash

# Setup supervisord config (for services running)
echo "> Setup supervisord config (for services running)"
echo "[supervisord]
nodaemon=true
user=root
pidfile=/var/run/supervisord.pid
logfile=/dev/null
logfile_maxbytes=0


" > /etc/supervisor/conf.d/supervisord.conf

echo "- Installation completed: supervisord.conf"