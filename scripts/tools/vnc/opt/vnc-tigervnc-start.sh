#!/bin/bash

# Load environment variables
source /etc/profile

# Start Tiger VNC
tigervncserver -xstartup /usr/bin/xfce4-session -SecurityTypes None -fg
