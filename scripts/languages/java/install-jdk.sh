#!/bin/bash
set -e

# Download JDK
echo "> Installing JDK"
space_before=$(df --output=avail / | tail -n 1)

wget $JDK_DOWNLOAD_URL -O /tmp/openjdk-linux-x64_bin.tar.gz -q
tar -C /tmp -xf /tmp/openjdk-linux-x64_bin.tar.gz
mkdir -p /usr/lib/jvm
mv "/tmp/jdk-${JDK_VERSION}" /usr/lib/jvm/
rm /tmp/openjdk-linux-x64_bin.tar.gz

# Download Maven
# See: https://maven.apache.org/download.cgi
echo ">> Installing Maven"

wget $MAVEN_DOWNLOAD_URL -O /tmp/apache-maven.tar.gz -q
tar -xf /tmp/apache-maven.tar.gz -C /opt
ln -s "/opt/apache-maven-${MAVEN_VERSION}" /opt/maven
rm /tmp/apache-maven.tar.gz

# Setup Environment Variables
echo ">> Setup Java environment variables"

echo "export JAVA_HOME=\"/usr/lib/jvm/jdk-$JDK_VERSION\"
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=\"\$M2_HOME/bin:\$JAVA_HOME/bin:\$PATH\"" > /etc/profile.d/java-env.sh

# Display install size
echo "- Installation completed: Java and Maven"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / | tail -n 1) )))"