from dotenv import load_dotenv 
from bs4 import BeautifulSoup
from packaging import version
import sys
import os
import requests
import re

load_dotenv()
error_info = []

# Debian
try:
    debian_stable_release = requests.get('https://deb.debian.org/debian/dists/stable/Release').text
    debian_codename = re.search(r'Codename: (\w+)', debian_stable_release).group(1)
    debian_version = re.search(r"Version: (\d+)", debian_stable_release).group(1)
except Exception as e:
    error_info.append(("Debian", e))
    debian_codename = os.getenv('DEBIAN_CODENAME')
    debian_version = os.getenv('DEBIAN_VERSION')

# Dotnet
try:
    dotnet_packages = requests.get(f"https://packages.microsoft.com/debian/{debian_version}/prod/dists/{debian_codename}/main/binary-amd64/Packages").text
    dotnet_sdk_versions = sorted(re.findall(r'Package: dotnet-sdk-(\d+\.\d+)', dotnet_packages), key=lambda v: version.parse(v), reverse=True)
    dotnet_version = dotnet_sdk_versions[0]
except Exception as e:
    error_info.append(("Dotnet", e))
    dotnet_version = os.getenv('DOTNET_VERSION')

# Rust Stable
try:
    rust_stable_channel = requests.get(f"https://static.rust-lang.org/dist/channel-rust-stable.toml").text
    rust_versions = re.findall(r'version = "(.*?) \(', rust_stable_channel)
    rust_version = max(rust_versions, key=version.parse)
except Exception as e:
    error_info.append(("Rust", e))
    rust_version = os.getenv('RUST_VERSION')

# Node LTS
try:
    node_releases = response = requests.get("https://nodejs.org/dist/index.json").json()
    node_lts_releases = [release['version'].lstrip('v') for release in node_releases if release.get('lts') != False]
    node_version = max(node_lts_releases, key=lambda release: version.parse(release))
except Exception as e:
    error_info.append(("Node", e))
    node_version = os.getenv('NODE_VERSION')

# Java JDK
try:
    processor_type = '_linux-x64_bin.tar.gz'
    
    jdk_home_page = BeautifulSoup(requests.get("https://jdk.java.net/").text, 'html.parser')
    jdk_download_page_link = jdk_home_page.find(lambda tag: tag.name == "a" and 'JDK' in tag.text and tag['href'])['href']
    jdk_dowload_page_url = jdk_download_page_link if jdk_download_page_link.startswith('http') else f"https://jdk.java.net/{(jdk_download_page_link.lstrip('/'))}"
    
    jdk_download_page = BeautifulSoup(requests.get(jdk_dowload_page_url).text, 'html.parser')
    jdk_dowload_link = jdk_download_page.find(lambda tag: tag.name == "a" and tag['href'] is not None and processor_type in tag['href'])['href']
    jdk_download_url = jdk_dowload_link if jdk_dowload_link.startswith('http') else f"https://jdk.java.net/{(jdk_dowload_link.lstrip('/'))}"
    jdk_version = re.search(r"jdk-(\d+\.\d+\.\d+)", jdk_download_url).group(1)
except Exception as e:
    error_info.append(("Java JDK", e))
    jdk_version = os.getenv('JDK_VERSION')
    jdk_download_url = os.getenv('JDK_DOWNLOAD_URL')

# Go
try:
    processor_type = '.linux-amd64.tar.gz'
    go_download_page = BeautifulSoup(requests.get("https://go.dev/dl/").text, 'html.parser')
    go_download_link = go_download_page.find(lambda tag: tag.name == "a" and tag['href'] is not None and processor_type in tag['href'])['href']
    go_download_url = go_download_link if go_download_link.startswith('http') else f"https://go.dev/dl/{(go_download_link.lstrip('/'))}"
    go_version = re.search(r"go(\d+\.\d+\.\d+)", go_download_url).group(1)
except Exception as e:
    error_info.append(("Go", e))
    go_version = os.getenv('GO_VERSION')
    go_download_url = os.getenv('GO_DOWNLOAD_URL')

# Conan
try:
    conan_version = requests.get("https://api.github.com/repos/conan-io/conan/releases/latest").json()['tag_name']
except Exception as e:
    error_info.append(("Conan", e))
    conan_version = os.getenv('CONAN_VERSION')
    
# PHP
try:
    php_packages = requests.get(f"https://packages.sury.org/php/dists/{debian_codename}/main/binary-amd64/Packages").text
    php_packages_versions = sorted(re.findall(r'Package: php(\d+\.\d+)', php_packages), key=lambda v: version.parse(v), reverse=True)
    php_version = php_packages_versions[0]
except Exception as e:
    error_info.append(("Php", e))
    php_version = os.getenv('PHP_VERSION')

# NGinx
try:
    nginx_packages = requests.get(f"https://nginx.org/packages/debian/dists/{debian_codename}/nginx/binary-amd64/Packages").text
    nginx_packages_versions = sorted(re.findall(r'Package: nginx\nVersion: (\d+\.\d+.\d+)', nginx_packages), key=lambda v: version.parse(v), reverse=True)
    nginx_version = nginx_packages_versions[0]
except Exception as e:
    error_info.append(("Nginx", e))
    nginx_version = os.getenv('NGINX_VERSION')    

# Code Server
try:
    code_server_version = requests.get("https://api.github.com/repos/coder/code-server/releases/latest").json()['tag_name'].lstrip('v')
except Exception as e:
    error_info.append(("Code Server", e))
    code_server_version = os.getenv('CODE_SERVER_VERSION')

# Python
try:
    python_download_page_links = BeautifulSoup(requests.get("https://www.python.org/downloads/").text, 'html.parser')
    python_version_pattern = re.compile("Download Python (\d+\.\d+(?:\.\d+)?)")
    python_download_page_link = python_download_page_links.find(lambda tag: tag.name == "a" and python_version_pattern.search(tag.text) is not None)
    python_version = python_version_pattern.search(python_download_page_link.text).group(1)
except Exception as e:
    error_info.append(("Python", e))
    python_version = os.getenv('PYTHON_VERSION')

# Dev Container Version
dev_container_version = version.parse(os.getenv('DEV_CONTAINER_VERSION').split('-')[1] if os.getenv('DEV_CONTAINER_VERSION') else "1.0")

versions_to_check = [
    ('DEBIAN_VERSION', debian_version, 'major'),
    ('DOTNET_VERSION', dotnet_version, 'major'),
    ('RUST_VERSION', rust_version, 'major'),
    ('NODE_VERSION', node_version, 'major'),
    ('JDK_VERSION', jdk_version, 'major'),
    ('GO_VERSION', go_version, 'minor'),
    ('CONAN_VERSION', conan_version, 'major'),
    ('PHP_VERSION', php_version, 'major'),
    ('NGINX_VERSION', nginx_version, 'major'),
    ('CODE_SERVER_VERSION', code_server_version, 'major'),
    ('PYTHON_VERSION', python_version, 'minor'),
]

for v in versions_to_check:
    old_version = version.parse(os.getenv(v[0]) if os.getenv(v[0]) else "0.0.0")
    new_version = version.parse(str(v[1]))
    bump_version = False
    
    if new_version < old_version:
        print(f"Error, new version for {v[0]} is older than the current version we have ({new_version} < {old_version})");
        sys.exit(1)
    
    if new_version == old_version:
        continue
    
    if v[2] == 'major' and new_version.major > old_version.major:
        bump_version = True
    
    if v[2] == 'minor' and (new_version.major > old_version.major or new_version.minor > old_version.minor):
        bump_version = True

if bump_version:
    major = dev_container_version.major
    minor = dev_container_version.minor + 1
    dev_container_version = f"{major}.{minor}"
    print(f"Version bumped: {dev_container_version} -> {major}.{minor}")

# Result
versions = f"""DEV_CONTAINER_VERSION={debian_codename}-{dev_container_version}
DEV_CONTAINER_USER={os.getenv('DEV_CONTAINER_USER')}
DEV_CONTAINER_USER_GROUP={os.getenv('DEV_CONTAINER_USER_GROUP')}
DEBIAN_CODENAME={debian_codename}
DEBIAN_VERSION={debian_version}
DOTNET_VERSION={dotnet_version}
RUST_VERSION={rust_version}
NODE_VERSION={node_version}
JDK_VERSION={jdk_version}
JDK_DOWNLOAD_URL={jdk_download_url}
GO_VERSION={go_version}
GO_DOWNLOAD_URL={go_download_url}
CONAN_VERSION={conan_version}
PHP_VERSION={php_version}
NGINX_VERSION={nginx_version}
CODE_SERVER_VERSION={code_server_version}
PYTHON_VERSION={python_version}
"""

# Write dotenv file
dotenv_file = '.env'
if bump_version:
    print('Updating versions')
    print(versions)
    with open(dotenv_file, 'w') as file:
        file.write(versions)
else:
    print('No change detected')

# Display errors if any
if len(error_info) > 0:
    for e in error_info:
        print(f"Error checking {e[0]} version: {str(e[1])}")
    sys.exit(1)

# Clean exit
sys.exit(0)