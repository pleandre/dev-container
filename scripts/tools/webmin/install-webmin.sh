#!/bin/bash
set -e

# Install webmin
echo "> Installing webmin"
space_before=$(df --output=avail / | tail -n 1)

echo ">> Adding webmin repository"
curl -fsSL "https://download.webmin.com/developers-key.asc" | gpg --dearmor --yes -o /etc/apt/keyrings/debian-webmin-developers.gpg
echo "deb [signed-by=/etc/apt/keyrings/debian-webmin-developers.gpg] https://download.webmin.com/download/newkey/repository stable contrib" > /etc/apt/sources.list.d/webmin.list
apt update -qq

echo ">> Installing webmin"
apt install -qq -y webmin

# Display install size
echo "- Installation completed: webmin"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / | tail -n 1) )))"