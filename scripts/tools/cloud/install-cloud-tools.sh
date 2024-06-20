#!/bin/bash
set -e

echo "> Installing cloud tools"
space_before=$(df --output=avail / --block-size=1 | tail -n 1)

# Install gcloud cli
# See: https://cloud.google.com/sdk/docs/install#deb
echo ">> Installing gcloud cli"
apt install -y -qq \
	apt-transport-https \
	ca-certificates \
	sudo \
	unzip \
	curl \
	lsb-release \
	gnupg

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor --yes -o /etc/apt/keyrings/cloud.google.gpg

echo "deb [signed-by=/etc/apt/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

apt update -qq
apt install -y -qq google-cloud-cli

# Install aws cli
echo ">> Installing aws cli"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
cd /tmp/
unzip -q awscliv2.zip
chmod +x /tmp/aws/install
/tmp/aws/install
rm awscliv2.zip
rm -rf aws
cd /scripts/

aws --version

# Install azure cli
echo ">> Installing azure cli"
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor --yes -o /etc/apt/keyrings/microsoft.gpg
echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $DEBIAN_CODENAME main" > /etc/apt/sources.list.d/azure-cli.list

apt update -qq
apt install -y -qq azure-cli

# Install ansible
echo ">> Installing ansible"
apt install -y -qq ansible

# Install kubectl
echo ">> Installing kubectl"
curl -o /tmp/kubectl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
rm -f /tmp/kubectl

# Install terraform
echo ">> Installing terraform"
curl -fsSL  https://apt.releases.hashicorp.com/gpg | gpg --dearmor --yes -o /etc/apt/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $DEBIAN_CODENAME main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

apt update -qq
apt install -y -qq terraform

# Display install size
echo "- Installation completed: cloud tools"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / --block-size=1 | tail -n 1) )))"
