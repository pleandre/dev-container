#!/bin/bash
set -e

# Install Desktop
echo "> Installing Desktop: Xfce4, Firefox, Vs Code, One Password Desktop"
space_before=$(df --output=avail / --block-size=1 | tail -n 1)

# Install Xfse4 Desktop - Minimal Installation
# See: https://github.com/coonrad/Debian-Xfce4-Minimal-Install
echo ">> Installing Xfse4 Desktop"
space_before_cmd=$(df --output=avail / --block-size=1 | tail -n 1)
apt install -y -qq \
    libxfce4ui-utils \
    thunar \
    xfce4-appfinder \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xfce4-terminal \
    xfce4-taskmanager \
    xfce4-screenshooter \
    xfconf \
    xfdesktop4 \
    xfwm4
echo ">> Installed Xfse4 Desktop: $(numfmt --to=iec $(( space_before_cmd - $(df --output=avail / --block-size=1 | tail -n 1) )))"

echo ">> Installing Firefox"
space_before_cmd=$(df --output=avail / --block-size=1 | tail -n 1)
apt install -qq -y firefox-esr
echo ">> Installed firefox: $(numfmt --to=iec $(( space_before_cmd - $(df --output=avail / --block-size=1 | tail -n 1) )))"

# Chrome has some stability issues
# Firefox seems to be more stable in this setup (Docker, Debian 12, Xfce4, supervisord, VNC)
# We add the repository in case you want to try: apt install -y -qq google-chrome-stable
echo ">> Adding Chrome Repository"
curl -fsSL "https://dl.google.com/linux/linux_signing_key.pub" | gpg --dearmor --yes -o /etc/apt/keyrings/google-chrome.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt update -qq

echo ">> Installing One Password Desktop"
space_before_cmd=$(df --output=avail / --block-size=1 | tail -n 1)
apt install -qq -y 1password
echo ">> Installed One Password Desktop: $(numfmt --to=iec $(( space_before_cmd - $(df --output=avail / --block-size=1 | tail -n 1) )))"

echo ">> Installing VsCode"
space_before_cmd=$(df --output=avail / --block-size=1 | tail -n 1)
curl -fsSL "https://packages.microsoft.com/keys/microsoft.asc" | gpg --dearmor --yes -o /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
apt update -qq
apt install -y -qq code
echo ">> Installed VsCode Desktop: $(numfmt --to=iec $(( space_before_cmd - $(df --output=avail / --block-size=1 | tail -n 1) )))"

echo ">> Copying vscode script to install extensions and startup scripts"
mkdir -p /opt/dev-container/desktop/
cp /scripts/tools/desktop/opt/* /opt/dev-container/desktop/

mkdir -p /opt/dev-container/desktop/data/
touch /opt/dev-container/desktop/data/installed-vscode-desktop-extensions.txt

echo ">> Set /opt/dev-container/desktop/ access rights"
chown -R ${DEV_CONTAINER_USER}:${DEV_CONTAINER_USER_GROUP} /opt/dev-container/desktop/
find /opt/dev-container/desktop/ -type d -exec chmod u+rwx,g+rwx,o+rx '{}' \;
find /opt/dev-container/desktop/ -type f -exec chmod u+rw,g+rw,o+r '{}' \;

echo ">> Installing default vscode extensions"
space_before_cmd=$(df --output=avail / --block-size=1 | tail -n 1)
su -l $DEV_CONTAINER_USER /bin/bash -c "/opt/dev-container/desktop/install-vscode-desktop-extensions.sh"
echo ">> Installed default vscode extensions: $(numfmt --to=iec $(( space_before_cmd - $(df --output=avail / --block-size=1 | tail -n 1) )))"

echo ">> Setup script to run on startup"
echo "[program:desktop]
environment=HOME=\"/home/${DEV_CONTAINER_USER}\"
command=bash -c '/opt/dev-container/desktop/desktop-startup-script.sh'
directory=/home/${DEV_CONTAINER_USER}/
user=${DEV_CONTAINER_USER}
autostart=true
autorestart=false
stopwaitsecs=3
stopasgroup=true
killasgroup=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true
startsecs=0
exitcodes=0

" >> /etc/supervisor/conf.d/supervisord.conf

# Setup environment variables
echo ">> Copy Desktop Environment Variables"
cp /scripts/tools/desktop/desktop-env.sh /etc/profile.d/desktop-env.sh

# Display install size
echo "- Installation completed: Desktop (Xfce4, Firefox, Vs Code, One Password Desktop)"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / --block-size=1 | tail -n 1) )))"
