#!/bin/bash
set -e

# Install JetBrain Products
# https://dev.to/jorgecastro/install-jetbrains-toolbox-on-linux-596n
echo "> Install JetBrain Toolbox"
space_before=$(df --output=avail / | tail -n 1)

wget ${JETBRAINS_TOOLBOX_DOWNLOAD_URL} -O /tmp/jetbrains-toolbox.tar.gz -q
mkdir -p /tmp/jetbrains-toolbox
tar -C /tmp/jetbrains-toolbox -xf /tmp/jetbrains-toolbox.tar.gz

# Folder structure will be /tmp/jetbrains-toolbox/jetbrains-toolbox-2.3.2.31487 for example
# 2.3.2.31487 is a version and can change so we move the content of this directory one level up
pushd /tmp/jetbrains-toolbox
for dir in *; do
    if [ -d "$dir" ]; then
        if ls "$dir"/* &> /dev/null; then
            mv "$dir"/* .
            rm -rf "$dir"
            break
        fi
    fi
done
popd

# Move jetbrains toolbox to opt folder
mkdir -p /opt/jetbrains/
chmod 755 /opt/jetbrains/
mv /tmp/jetbrains-toolbox/jetbrains-toolbox /opt/jetbrains/jetbrains-toolbox
chmod 755 /opt/jetbrains/jetbrains-toolbox

# Remove files
rm /tmp/jetbrains-toolbox.tar.gz
rm -rf /tmp/jetbrains-toolbox

# Create Desktop Shortcut
echo ">> Create Desktop Shortcut: JetBrain Toolbox"
cp /scripts/tools/jetbrains/jetbrains-toolbox-icon.png /opt/jetbrains/jetbrains-toolbox-icon.png
chmod 664 /opt/jetbrains/jetbrains-toolbox-icon.png

echo "[Desktop Entry]
Type=Application
Name=JetBrains Toolbox
Exec=/opt/jetbrains/jetbrains-toolbox
Icon=/opt/jetbrains/jetbrains-toolbox-icon.png
" > /usr/share/applications/jetbrains-toolbox.desktop

# Display install size
echo "- Installation completed: JetBrain Products"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / | tail -n 1) )))"
