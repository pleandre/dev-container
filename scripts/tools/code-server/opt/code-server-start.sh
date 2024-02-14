#!/bin/bash

# Load extensions if not loaded
/opt/code-server/install-extensions.sh

# Script ends and is replaced by code-server process (exec).
exec code-server --auth none --bind-addr 0.0.0.0:8080