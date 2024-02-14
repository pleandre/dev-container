#!/bin/bash
set -e

# Install go
echo "> Installing Go"
space_before=$(df --output=avail / | tail -n 1)

wget "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.linux-amd64.tar.gz -q
tar -C /usr/local -xzf "/tmp/go.linux-amd64.tar.gz"
rm /tmp/go.linux-amd64.tar.gz

# Add Permissions to dev-group to the folder:
# 7 read, write and execute for root
# 5 read and execute for dev-group
# 5 read and execute for others
chown -R root:$DEV_CONTAINER_USER_GROUP /usr/local/go
chmod -R 755 /usr/local/go

# Setup Environment Variables
echo ">> Copy Go environment variables"
cp /scripts/languages/go/go-env.sh /etc/profile.d/go-env.sh

# Display install size
echo "- Installation completed: go"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / | tail -n 1) )))"