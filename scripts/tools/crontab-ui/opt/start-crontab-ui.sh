#!/bin/bash

# Load environment variables
source /etc/profile

# Load node
. ~/.nvm/nvm.sh

export HOST=0.0.0.0
export PORT=8500 

# Start crontab ui
exec crontab-ui
