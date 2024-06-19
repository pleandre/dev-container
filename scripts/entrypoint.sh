#!/bin/bash
set -e

# Load environment variables
source /etc/profile

# Check if ROOT_PASSWORD is set and non-empty
if [ -n "$ROOT_PASSWORD" ]; then
  echo "root:$ROOT_PASSWORD" | chpasswd
  echo "Root password set successfully."
else
  echo "ROOT_PASSWORD environment variable is not set."
fi

# Check if DEV_USER_PASSWORD is set and non-empty
if [ -n "$DEV_USER_PASSWORD" ]; then
    echo "dev-user:$DEV_USER_PASSWORD" | chpasswd
    echo "dev-user password set successfully."
else
  echo "DEV_USER_PASSWORD environment variable is not set."
fi

# We start supervisord web service
echo "[inet_http_server]
port=*:9001

" > /etc/supervisor/conf.d/supervisord-web.conf


# Run supervisord
exec /usr/bin/supervisord --nodaemon