#!/bin/bash

# Load environment variables
source /etc/profile

# Load extensions if not loaded
/opt/dev-container/code-server/install-extensions.sh

# Set default values for code server args and parameters
export CODE_SERVER_AUTH=${CODE_SERVER_AUTH:-none}
export CODE_SERVER_PORT=${CODE_SERVER_PORT:-8080}
export CODE_SERVER_EXTRA_ARGS=${CODE_SERVER_EXTRA_ARGS:---disable-telemetry}

# Script ends and is replaced by code-server process (exec).
exec code-server --auth $CODE_SERVER_AUTH --host 0.0.0.0 --port $CODE_SERVER_PORT $CODE_SERVER_EXTRA_ARGS
