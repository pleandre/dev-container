#!/bin/bash

# Load environment variables
source /etc/profile

# Remove confirmation / warning when using code command:
# To use Visual Studio Code with the Windows Subsystem for Linux, please install Visual Studio Code in Windows and uninstall the Linux version in WSL.
export DONT_PROMPT_WSL_INSTALL=1

# Load VSCode Desktop extensions if not loaded
/opt/dev-container/desktop/install-vscode-desktop-extensions.sh
