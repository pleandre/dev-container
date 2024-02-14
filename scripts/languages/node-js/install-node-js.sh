#!/bin/bash
set -e

# Install NVM
echo "> Installing NVM"
space_before=$(df --output=avail / | tail -n 1)

su -l $DEV_CONTAINER_USER /bin/bash -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash"

# Install Node
# -l option, uses login and will load environment variables from /etc/profile.d/
# . ~/.nvm.sh will load nvm environment variables

echo ">> Installing Node"
su -l $DEV_CONTAINER_USER /bin/bash -c ". ~/.nvm/nvm.sh && nvm install ${NODE_VERSION}"
su -l $DEV_CONTAINER_USER /bin/bash -c ". ~/.nvm/nvm.sh && nvm use ${NODE_VERSION}"

# Enable Corepack
echo ">> Enable Corepack"
su -l $DEV_CONTAINER_USER /bin/bash -c ". ~/.nvm/nvm.sh && corepack enable"


# Display install size
echo "- Installation completed: NVM, Node, Corepack"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / | tail -n 1) )))"