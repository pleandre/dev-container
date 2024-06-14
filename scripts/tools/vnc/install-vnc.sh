#!/bin/bash
set -e

# Install VNC
echo "> Installing Xfce4, Chrome, Vs Code, One Password Desktop, TigerVNC, NoVNC, XRDP"
space_before=$(df --output=avail / | tail -n 1)

# Install Xfse4 Desktop - Minimal Installation
# See: https://github.com/coonrad/Debian-Xfce4-Minimal-Install
# Need dbus-x11 to work with TigerVNC
echo ">> Installing Xfse4 Desktop"
apt install -y -qq \
    libxfce4ui-utils \
    thunar \
    xfce4-appfinder \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xfce4-terminal \
    xfconf \
    xfdesktop4 \
    xfwm4

echo ">> Installing Chrome"
curl -fsSL "https://dl.google.com/linux/linux_signing_key.pub" | gpg --dearmor --yes -o /etc/apt/keyrings/google-chrome.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt update -qq
apt install -y -qq google-chrome-stable

echo ">> Installing VsCode"
curl -fsSL "https://packages.microsoft.com/keys/microsoft.asc" | gpg --dearmor --yes -o /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
apt update -qq
apt install -y -qq code

echo ">> Installing One Password Desktop"
apt install -qq -y 1password

echo ">> Installing Tiger VNC"
apt install -qq -y tigervnc-standalone-server
su -l $DEV_CONTAINER_USER /bin/bash -c "tigervncserver -xstartup /usr/bin/xfce4-session -localhost no -SecurityTypes None --I-KNOW-THIS-IS-INSECURE :1"

echo ">> Installing No VNC Server"
# TODO: Replace with more recent version, similar to https://github.com/SeleniumHQ/docker-selenium/blob/trunk/NodeBase/Dockerfile#L107
apt install -qq -y novnc python3-websockify
websockify -D --web=/usr/share/novnc/ 6080 localhost:5901

echo ">> Installing XRDP"
apt install -qq -y xrdp
/etc/init.d/xrdp start

# Display install size
echo "- Installation completed: Xfce4, Chrome, Vs Code, One Password Desktop, TigerVNC, NoVNC, XRDP"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / | tail -n 1) )))"
