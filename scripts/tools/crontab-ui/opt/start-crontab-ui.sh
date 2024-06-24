#!/bin/bash

LOG_FILE="/var/log/crontab-ui/crontab-ui.log"

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

# Check if crontab-ui is installed
which crontab-ui >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    echo "crontab-ui not found in PATH" > $LOG_FILE
    exit 1
fi

# Start crontab ui
echo "Starting crontab-ui" > $LOG_FILE

export HOST=0.0.0.0
export PORT=8500 

crontab-ui >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
    echo "Failed to start crontab-ui" >> $LOG_FILE
    exit 1
fi