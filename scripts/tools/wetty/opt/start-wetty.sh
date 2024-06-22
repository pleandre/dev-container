#!/bin/bash

mkdir -p /var/log/wetty
LOG_FILE="/var/log/wetty/wetty.log"

# Log and load environment variables
. /etc/profile
if [ $? -ne 0 ]; then
    echo "Failed to source /etc/profile" > $LOG_FILE
    exit 1
fi

# Load node
. "${HOME}/.nvm/nvm.sh"
if [ $? -ne 0 ]; then
    echo "Failed to source nvm.sh" > $LOG_FILE
    exit 1
fi

# Check if wetty is installed
which wetty >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    echo "Wetty not found in PATH" > $LOG_FILE
    exit 1
fi

# Start wetty ui
echo "Starting Wetty" > $LOG_FILE
wetty --port 7500 >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    echo "Failed to start Wetty" >> $LOG_FILE
    exit 1
fi