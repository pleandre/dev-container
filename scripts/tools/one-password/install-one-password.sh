#!/bin/bash
set -e

# Install One Password CLI
echo "> Installing One Password CLI"
space_before=$(df --output=avail / | tail -n 1)

# Add the key for the 1Password apt repository
curl -fsSL "https://downloads.1password.com/linux/keys/1password.asc" | gpg --dearmor --yes -o /usr/share/keyrings/1password-archive-keyring.gpg

# Add the 1Password apt repository:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" > /etc/apt/sources.list.d/1password.list

# Add the debsig-verify policy:
mkdir -p /etc/debsig/policies/AC2D62742012EA22/
mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sSLo /etc/debsig/policies/AC2D62742012EA22/1password.pol https://downloads.1password.com/linux/debian/debsig/1password.pol
curl -fsSL "https://downloads.1password.com/linux/keys/1password.asc" | gpg --dearmor --yes -o /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

# Install 1 Password CLI
apt update -qq
apt install -qq -y 1password-cli

# Display version installed
op --version

# Display install size
echo "- Installation completed: One Password CLI"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / | tail -n 1) )))"
