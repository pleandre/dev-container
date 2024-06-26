#!/bin/bash
set -e

# Install VNC
echo "> Installing TigerVNC, dbus-x11, noVNC, XRDP"
space_before=$(df --output=avail / --block-size=1 | tail -n 1)

echo ">> Installing Tiger VNC and dbus-x11"
apt install -qq -y tigervnc-standalone-server dbus-x11

echo ">> Installing No VNC Server: Web UI"
# Download and extract files
wget "${NO_VNC_DOWNLOAD_URL}" -O /tmp/noVnc.tar.gz -q
mkdir -p /tmp/noVnc
tar -C /tmp/noVnc -xf /tmp/noVnc.tar.gz

# Folder structure will be /tmp/noVnc/novnc-noVNC-52f5a95 for example
# 52f5a95 is a hash and can change we move the content of this directory one level up
pushd /tmp/noVnc
for dir in *; do
    if [ -d "$dir" ]; then
        if ls "$dir"/* &> /dev/null; then
            mv "$dir"/* .
            rm -rf "$dir"
            break
        fi
    fi
done
popd

# Copy vnc.html into index.html
cp /tmp/noVnc/vnc.html /tmp/noVnc/index.html

# Move to permanent folder
mv /tmp/noVnc /usr/share/novnc/

# Remove folders
rm /tmp/noVnc.tar.gz

# Change Ownership
chown -R ${DEV_CONTAINER_USER}:${DEV_CONTAINER_USER_GROUP} /usr/share/novnc/

echo ">> Installing XRDP"
apt install -qq -y xrdp

echo ">> Copying vnc startup scripts"
mkdir -p /opt/dev-container/vnc/
cp /scripts/tools/vnc/opt/* /opt/dev-container/vnc/

# Setup service
echo ">> Creating VNC and RDP services config in Supervisord"

echo "[program:vnc-novnc]
command=bash -c '/opt/dev-container/vnc/vnc-novnc-webui-start.sh'
directory=/home/${DEV_CONTAINER_USER}/
environment=HOME=\"/home/${DEV_CONTAINER_USER}\"
user=${DEV_CONTAINER_USER}
autostart=true
autorestart=true
stopwaitsecs=3
stopasgroup=true
killasgroup=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

[program:vnc-tigervnc]
command=bash -c '/opt/dev-container/vnc/vnc-tigervnc-start.sh'
directory=/home/${DEV_CONTAINER_USER}/
environment=HOME=\"/home/${DEV_CONTAINER_USER}\"
user=${DEV_CONTAINER_USER}
autostart=true
autorestart=true
stopwaitsecs=3
stopasgroup=true
killasgroup=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

[program:rdp-sesman]
command=bash -c '/opt/dev-container/vnc/rdp-sesman-start.sh'
directory=/home/
user=root
autostart=true
autorestart=true
stopwaitsecs=3
stopasgroup=true
killasgroup=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

[program:rdp]
command=bash -c '/opt/dev-container/vnc/rdp-start.sh'
directory=/home/
user=root
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
echo "- Installation completed: TigerVNC, dbus-x11, noVNC, XRDP"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / --block-size=1 | tail -n 1) )))"
