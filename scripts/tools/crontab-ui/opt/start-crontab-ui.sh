#!/bin/bash

# Load environment variables
source /etc/profile

# Load node
. ~/.nvm/nvm.sh

# Start crontab ui
exec crontab-ui
