#!/bin/bash
set -e

# Settings
NAME="DataGrip"
DOWNLOAD_URL="https://download.jetbrains.com/datagrip/datagrip-2024.3.5.tar.gz"
PRODUCT_CODE="DG"
BIN_FILE="datagrip.sh"
DESTINATION="/opt/jetbrains/${PRODUCT_CODE}/"
BIN_SIMLINK="${DESTINATION}${BIN_FILE}"

# Load environment variables
source /etc/profile

# If file folder already exist we run the app
if [ -d "$DESTINATION" ]; then
    # If SimLink is not created, app is still installing or instalation failed
    if [ ! -L "$BIN_SIMLINK" ]; then
        MESSAGE="The application is still installing or the installation failed. Please wait or remove folder '${DESTINATION}' to retry."
        if [ -n "$DISPLAY" ]; then
            zenity --warning --text="$MESSAGE" &
        fi
        echo "$MESSAGE"
        
        exit 0
    fi
    
	exec ${BIN_SIMLINK} "$@"
fi

echo "> Installing: ${NAME}"
if [ -n "$DISPLAY" ]; then
    zenity --info --text="Please wait while ${NAME} is installing. It will start once done." & ZENITY_PID=$!
fi

# Otherwise we install the app
# Create the directory
mkdir -p "${DESTINATION}"
chmod 755 "${DESTINATION}"

# Download the app
echo "> Downloading ${NAME}: ${DOWNLOAD_URL}"
TAR_FILE="/tmp/${PRODUCT_CODE}.tar.gz"
wget "${DOWNLOAD_URL}" -O "${TAR_FILE}" -q

# Extract tarball
echo "> Extracting ${NAME}"
tar -C "${DESTINATION}" -xf "${TAR_FILE}"

# We get current version path
# Folder structure will be /opt/jetbrains/RR/RustRover-2024.1.2
EXTRACTED_DIR=$(tar -tf "${TAR_FILE}" | head -1 | cut -f1 -d"/")
EXTRACTED_PATH="${DESTINATION}${EXTRACTED_DIR}/"
BIN_PATH="${EXTRACTED_PATH}bin/${BIN_FILE}"

# Remove tarball
echo "> Cleaning up"
rm -rf "${TAR_FILE}"

# Create symlinks
ln -s "${BIN_PATH}" "${BIN_SIMLINK}"

# Copy shortcut to desktop
mkdir -p "$HOME/Desktop/"
cp "/usr/share/applications/jetbrains-${PRODUCT_CODE}.desktop" "$HOME/Desktop/"

# Inform the user that the installation is complete
echo "- Installation Completed! ${NAME}"
if [ -n "$DISPLAY" ] && kill -0 $ZENITY_PID 2>/dev/null; then
    kill $ZENITY_PID
    zenity --info --text="${NAME} installation is complete."
fi

# Run app
exec ${BIN_SIMLINK} "$@"