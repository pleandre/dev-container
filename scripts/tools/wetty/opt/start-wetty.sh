#!/bin/bash

# Load environment variables
source /etc/profile

# Load node
. ~/.nvm/nvm.sh

# Start wetty ui
exec wetty --port 7500
