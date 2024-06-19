#!/bin/bash
set -e

# Settings
NAME="WebStorm"
DOWNLOAD_URL="https://download.jetbrains.com/webstorm/WebStorm-2024.1.4.tar.gz"
PRODUCT_CODE="WS"
BIN_FILE="webstorm.sh"
DESTINATION="/opt/jetbrains/${PRODUCT_CODE}/"
BIN_SIMLINK="${DESTINATION}${BINFILE}"

# Load environment variables
source /etc/profile

# If file folder already exist we run the app
if [ -d "$DESTINATION" ]; then
	${BIN_SIMLINK} "$@"
fi

# Otherwise we install the app
# Create the directory
mkdir -p "${DESTINATION}"
chmod 755 "${DESTINATION}"

# Download the app
TAR_FILE="${DESTINATION}${PRODUCT_CODE}.tar.gz"
wget "${DOWNLOAD_URL}" -O "${TAR_FILE}" -q

# Extract tarball
tar -C "${DESTINATION}" -xf "${TAR_FILE}"

# We get current version path
# Folder structure will be /opt/jetbrains/RR/RustRover-2024.1.2
EXTRACTED_DIR=$(tar -tf "${TAR_FILE}" | head -1 | cut -f1 -d"/")
EXTRACTED_PATH="${DESTINATION}${EXTRACTED_DIR}/"
BIN_PATH="${EXTRACTED_PATH}bin/${BIN_FILE}"

# Remove tarball
rm -rf "${TAR_FILE}"

# Create symlinks
ln -s "${BIN_PATH}" "${BIN_SIMLINK}"

# Run app
${BIN_SIMLINK} "$@"