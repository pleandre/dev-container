#!/bin/bash
set -e

# Install C and C++ Programming tools
echo "> Installing C and C++ Programming Tools"
space_before=$(df --output=avail / --block-size=1 | tail -n 1)

apt install -qq -y build-essential \
	make \
	tar \
	curl \
	zip \
	unzip \
	cmake \
	gdb \
	cppcheck \
	valgrind \
	git \
	libboost-all-dev

# Install vcpkg
echo ">> Installing Vcpkg"

cd /opt/
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.sh
cd /scripts/

# Install conan
echo ">> Installing Conan"

wget ${CONAN_DOWNLOAD_URL} -O /tmp/conan.deb -q
dpkg -i /tmp/conan.deb
rm -rf /tmp/conan.deb

# Setup Environment Variables
echo ">> Copy C environment variables"
cp /scripts/languages/c/c-env.sh /etc/profile.d/c-env.sh

# Display install size
echo "- Installation completed: C and C++ Programming Tools"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / --block-size=1 | tail -n 1) )))"