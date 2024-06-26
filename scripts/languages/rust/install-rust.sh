#!/bin/bash
set -e

echo "> Installing Rust"
space_before=$(df --output=avail / --block-size=1 | tail -n 1)

echo ">> Installing Rust Dependencies"
space_before_cmd=$(df --output=avail / --block-size=1 | tail -n 1)
apt install -y -qq \
	curl \
	build-essential \
	gcc \
	make \
	wget \
	tar
echo ">> Installed Rust Dependencies: $(numfmt --to=iec $(( space_before_cmd - $(df --output=avail / --block-size=1 | tail -n 1) )))"

# To Install Rust System wide, we use the standalone installer
# https://forge.rust-lang.org/infra/other-installation-methods.html#standalone
echo ">> Downloading Rust Package"
space_before_cmd=$(df --output=avail / --block-size=1 | tail -n 1)
wget "https://static.rust-lang.org/dist/rust-${RUST_VERSION}-x86_64-unknown-linux-gnu.tar.gz" -O /tmp/rust-install.tar.gz -q
tar -C /tmp -xf /tmp/rust-install.tar.gz

echo ">> Running Rust Install"
/tmp/rust-${RUST_VERSION}-x86_64-unknown-linux-gnu/install.sh
rm -rf /tmp/rust-${RUST_VERSION}-x86_64-unknown-linux-gnu/
rm -rf /tmp/rust-install.tar.gz
echo ">> Installed Rust Tarball: $(numfmt --to=iec $(( space_before_cmd - $(df --output=avail / --block-size=1 | tail -n 1) )))"

# Setup Environment Variables
echo ">> Copy Rust environment variables"
cp /scripts/languages/rust/rust-env.sh /etc/profile.d/rust-env.sh

# Display install size
echo "- Installation completed: Rust"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / --block-size=1 | tail -n 1) )))"
