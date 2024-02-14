#!/bin/bash
set -e

# Install dotnet SDK
# See: https://learn.microsoft.com/en-us/dotnet/core/install/linux-debian
echo "> Installing Dotnet SDK"
space_before=$(df --output=avail / | tail -n 1)

wget "https://packages.microsoft.com/config/debian/${DEBIAN_VERSION}/packages-microsoft-prod.deb" -O /tmp/packages-microsoft-prod.deb -q
dpkg -i /tmp/packages-microsoft-prod.deb
rm /tmp/packages-microsoft-prod.deb

# Install package
apt update -qq
apt install -y -qq "dotnet-sdk-${DOTNET_VERSION}"

# Display install size
echo "- Installation completed: Dotnet SDK"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / | tail -n 1) )))"