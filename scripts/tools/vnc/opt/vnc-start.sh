#!/bin/bash

# Load environment variables
source /etc/profile

# Start Tiger VNC
tigervncserver -xstartup /usr/bin/xfce4-session -SecurityTypes None

# Todo
# https://github.com/novnc/noVNC/blob/master/utils/novnc_proxy
# Handle certificate
/usr/share/novnc/utils/novnc_proxy --file-only --web /usr/share/novnc/ --listen 6080 --vnc localhost:5901
