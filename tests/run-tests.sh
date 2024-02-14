#!/bin/bash

# To have a return code based on the success of all the commands
set -e

# Load environment variables
source /etc/profile

# Check supervisord is installed and check config
echo "- Running supervisord tests"
supervisord --version

# Check dotnet is installed
echo "- Running dotnet tests"
dotnet --version

# Check rust is installed
echo "- Running rust tests"
rustc --version
cargo --version

# Check node
echo "- Running node tests"
su -l $DEV_CONTAINER_USER nvm --version
su -l $DEV_CONTAINER_USER node --version
su -l $DEV_CONTAINER_USER npm --version
su -l $DEV_CONTAINER_USER yarn --version

# Check go
echo "- Running go tests"
go version

# Check C and CPP
echo "- Running c and cpp tests"
gcc --version
conan --version
vcpkg --version

# Check Java is installed
echo "- Running Java tests"
java -version
javac -version
if [ -z "$JAVA_HOME" ]; then
    echo "Error: JAVA_HOME is not set."
    exit 1
fi
if [ ! -d "$JAVA_HOME" ]; then
    echo "Error: The JAVA_HOME path does not exist: $JAVA_HOME"
    exit 1
fi
mvn --version

# Check Python
echo "- Running Python tests"
su -l $DEV_CONTAINER_USER conda --version

# Check PHP
echo "- Running PHP tests"
php --version
nginx -t
composer --version

# Check docker is installed
echo "- Running Docker tests"
docker --version

# Check One Password
echo "- Running One Password tests"
op --version

# Check Cloud Tools
echo "- Running Cloud Tools tests"
az --version
terraform version
ansible --version
aws --version
gcloud --version

# Check Code Server
echo "- Running Code Server tests"
code-server --version

echo "Tests completed"