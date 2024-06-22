#!/bin/bash
set -e

echo "> Installing JetBrains Scripts, Icons and Shortcuts"

# Install Zenity to display alerts and info dialog in the startup / installation scripts
apt install -qq -y zenity

# Create script folder
mkdir -p /opt/dev-container/jetbrains/scripts/

# Copy scripts
cp /scripts/tools/jetbrains/scripts/* /opt/dev-container/jetbrains/scripts/
chmod -R 775 /opt/dev-container/jetbrains/scripts/

# Copy all shortcuts and make sure they have the correct ownership
cp /scripts/tools/jetbrains/shortcuts/* /usr/share/applications/
chmod -R 775 /usr/share/applications/

# Copy icons 
mkdir -p /opt/dev-container/jetbrains/icons/
cp /scripts/tools/jetbrains/icons/* /opt/dev-container/jetbrains/icons/
chmod -R 664 /opt/dev-container/jetbrains/icons/
chmod 775 /opt/dev-container/jetbrains/icons/

# Copy environment variables (add /opt/dev-container/jetbrains/scripts/ to the path)
echo ">> Copy JetBrains Environment Variables"
cp /scripts/tools/jetbrains/jetbrains-env.sh /etc/profile.d/jetbrains-env.sh

echo "- Installation completed: JetBrains Scripts, Icons and Shortcuts"