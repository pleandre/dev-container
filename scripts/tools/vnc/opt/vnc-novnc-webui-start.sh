#!/bin/bash

# Load environment variables
source /etc/profile

# Start noVNC
# https://github.com/novnc/noVNC/blob/master/utils/novnc_proxy
/usr/share/novnc/utils/novnc_proxy --file-only --web /usr/share/novnc/ --listen 6080 --vnc localhost:5901
