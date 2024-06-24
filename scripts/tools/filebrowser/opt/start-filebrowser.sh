#!/bin/bash

LOG_FILE="/var/log/filebrowser/filebrowser.log"

# Log and load environment variables
. /etc/profile
if [ $? -ne 0 ]; then
    echo "Failed to source /etc/profile" > $LOG_FILE
    exit 1
fi

# Check if filebrowser is installed
which filebrowser >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    echo "filebrowser not found in PATH" > $LOG_FILE
    exit 1
fi

# Start filebrowser
echo "Starting filebrowser" > $LOG_FILE

filebrowser -r / -p 7000 --address 0.0.0.0 --noauth >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    echo "Failed to start filebrowser" >> $LOG_FILE
    exit 1
fi