#!/bin/bash

# Remove confirmation / warning when using code command:
# 	"To use Visual Studio Code with the Windows Subsystem for Linux, please install Visual Studio Code in Windows and uninstall the Linux version in WSL."
export DONT_PROMPT_WSL_INSTALL=1

# Load extensions if not loaded
EXTENSIONS="/opt/dev-container/code-server/extensions.json"
INSTALLED_EXTENSIONS="/opt/dev-container/code-server/data/installed-extensions.txt"

# Ensure installed extensions file exists
touch "$INSTALLED_EXTENSIONS" &>/dev/null

# Check if the EXTENSIONS file exists
if [ -f "$EXTENSIONS" ]; then
    # Read the list of extensions into an array
    readarray -t extensions < <(jq -r '.extensions[]' "$EXTENSIONS")

    # Iterate through the extensions array and install only if not already processed
    for extension in "${extensions[@]}"; do
        if ! grep -Fxq "$extension" "$INSTALLED_EXTENSIONS"; then
            echo ">> Adding extension: $extension"
            if code-server --install-extension "$extension"; then
                echo "$extension" >> "$INSTALLED_EXTENSIONS"
            else
                echo "Failed to install extension: $extension"
            fi
        fi
    done
fi
