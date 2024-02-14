#!/bin/bash
set -e

# Create user
echo "Creating user=${DEV_CONTAINER_USER} and group=${DEV_CONTAINER_USER_GROUP}"
useradd --create-home --shell /bin/bash $DEV_CONTAINER_USER

# Create dev group and add users
groupadd $DEV_CONTAINER_USER_GROUP
usermod -aG $DEV_CONTAINER_USER_GROUP root
usermod -aG $DEV_CONTAINER_USER_GROUP $DEV_CONTAINER_USER

echo "> Creating user, user-group and home completed"
