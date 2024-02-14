from dotenv import load_dotenv 
from bs4 import BeautifulSoup
from packaging import version
import subprocess
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
    
    print(f"Retrieved Debian codename successfully: {debian_codename}")
    print(f"Retrieved Debian version successfully: {debian_version}")
except Exception as e:
    error_info.append(("Debian", e))
    debian_codename = os.getenv('DEBIAN_CODENAME')
    debian_version = os.getenv('DEBIAN_VERSION')

# Dotnet
try:
    dotnet_packages = requests.get(f"https://packages.microsoft.com/debian/{debian_version}/prod/dists/{debian_codename}/main/binary-amd64/Packages").text
    dotnet_sdk_versions = sorted(re.findall(r'Package: dotnet-sdk-(\d+\.\d+)', dotnet_packages), key=lambda v: version.parse(v), reverse=True)
    dotnet_version = dotnet_sdk_versions[0]
    
    print(f"Retrieved Dotnet SDK version successfully: {dotnet_version}")
except Exception as e:
    error_info.append(("Dotnet", e))
    dotnet_version = os.getenv('DOTNET_VERSION')

# Rust Stable
try:
    rust_stable_channel = requests.get(f"https://static.rust-lang.org/dist/channel-rust-stable.toml").text
    rust_versions = re.findall(r'version = "(.*?) \(', rust_stable_channel)
    rust_version = max(rust_versions, key=version.parse)
    
    print(f"Retrieved Rust stable version successfully: {rust_version}")
except Exception as e:
    error_info.append(("Rust", e))
    rust_version = os.getenv('RUST_VERSION')

# NVM Version
try:
    nvm_version = requests.get("https://api.github.com/repos/nvm-sh/nvm/releases/latest").json()['tag_name']
    
    print(f"Retrieved Nvm version successfully: {nvm_version}")
except Exception as e:
    error_info.append(("Nvm", e))
    nvm_version = os.getenv('NVM_VERSION')

# Node LTS
try:
    node_releases = response = requests.get("https://nodejs.org/dist/index.json").json()
    node_lts_releases = [release['version'].lstrip('v') for release in node_releases if release.get('lts') != False]
    node_version = max(node_lts_releases, key=lambda release: version.parse(release))
    
    print(f"Retrieved Node LTS version successfully: {node_version}")
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
    
    print(f"Retrieved Java JDK version successfully: {jdk_version}")
    print(f"Retrieved Java JDK download URL successfully: {jdk_download_url}")
except Exception as e:
    error_info.append(("Java JDK", e))
    jdk_version = os.getenv('JDK_VERSION')
    jdk_download_url = os.getenv('JDK_DOWNLOAD_URL')

# Maven
try:
    download_type = '-bin.tar.gz'
    
    maven_download_page = BeautifulSoup(requests.get("https://maven.apache.org/download.cgi").text, 'html.parser')
    maven_download_link = maven_download_page.find(lambda tag: tag.name == "a" and download_type in tag.text)['href']
    maven_download_url = maven_download_link if maven_download_link.startswith('http') else f"https://maven.apache.org/{(maven_download_link.lstrip('/'))}"
    maven_version = re.search(r"apache-maven-(\d+\.\d+\.\d+)", maven_download_url).group(1)
    
    print(f"Retrieved Maven version successfully: {maven_version}")
    print(f"Retrieved Maven download URL successfully: {maven_download_url}")
except Exception as e:
    error_info.append(("Maven", e))
    maven_version = os.getenv('MAVEN_VERSION')
    maven_download_url = os.getenv('MAVEN_DOWNLOAD_URL')

# Go
try:
    processor_type = '.linux-amd64.tar.gz'
    go_download_page = BeautifulSoup(requests.get("https://go.dev/dl/").text, 'html.parser')
    go_download_link = go_download_page.find(lambda tag: tag.name == "a" and tag['href'] is not None and processor_type in tag['href'])['href']
    go_download_url = go_download_link if go_download_link.startswith('http') else f"https://go.dev/dl/{(go_download_link.lstrip('/'))}"
    go_version = re.search(r"go(\d+\.\d+\.\d+)", go_download_url).group(1)
    
    print(f"Retrieved Go version successfully: {go_version}")
    print(f"Retrieved Go download URL successfully: {go_download_url}")
except Exception as e:
    error_info.append(("Go", e))
    go_version = os.getenv('GO_VERSION')
    go_download_url = os.getenv('GO_DOWNLOAD_URL')

# Conan
try:
    conan_release = requests.get("https://api.github.com/repos/conan-io/conan/releases/latest").json()
    conan_version = conan_release['tag_name']
    conan_version_url = [asset['browser_download_url'] for asset in conan_release['assets'] if asset['browser_download_url'].endswith('.deb')][0]
    
    print(f"Retrieved Conan version successfully: {conan_version}")
except Exception as e:
    error_info.append(("Conan", e))
    conan_version = os.getenv('CONAN_VERSION')
    conan_version_url = os.getenv('CONAN_VERSION_URL')
    
# PHP
try:
    php_packages = requests.get(f"https://packages.sury.org/php/dists/{debian_codename}/main/binary-amd64/Packages").text
    php_packages_versions = sorted(re.findall(r'Package: php(\d+\.\d+)', php_packages), key=lambda v: version.parse(v), reverse=True)
    php_version = php_packages_versions[0]
    
    print(f"Retrieved PHP version successfully: {php_version}")
except Exception as e:
    error_info.append(("Php", e))
    php_version = os.getenv('PHP_VERSION')

# NGinx
try:
    nginx_packages = requests.get(f"https://nginx.org/packages/debian/dists/{debian_codename}/nginx/binary-amd64/Packages").text
    nginx_packages_versions = sorted(re.findall(r'Package: nginx\nVersion: (\d+\.\d+.\d+)', nginx_packages), key=lambda v: version.parse(v), reverse=True)
    nginx_version = nginx_packages_versions[0]
    
    print(f"Retrieved Nginx version successfully: {nginx_version}")
except Exception as e:
    error_info.append(("Nginx", e))
    nginx_version = os.getenv('NGINX_VERSION')    

# Code Server
try:
    code_server_version = requests.get("https://api.github.com/repos/coder/code-server/releases/latest").json()['tag_name'].lstrip('v')
    
    print(f"Retrieved Code Server version successfully: {code_server_version}")
except Exception as e:
    error_info.append(("Code Server", e))
    code_server_version = os.getenv('CODE_SERVER_VERSION')

# Python
try:
    python_versions = [pkg_info['version'] for pkg_info in requests.get('https://repo.anaconda.com/pkgs/main/linux-64/repodata.json').json()['packages'].values() if pkg_info['name'] == 'python']
    python_version = max(python_versions, key=version.parse)

    print(f"Retrieved Python version successfully: {python_version}")
except Exception as e:
    error_info.append(("Python", e))
    python_version = os.getenv('PYTHON_VERSION')

# JupyterLab
jupyter_lab_requirements_changed = False
try:
    requirements_in = "./scripts/tools/jupyter-lab/requirements-conda-dev.in"
    requirements_out = "./scripts/tools/jupyter-lab/requirements-conda-dev.txt"
    
    try:
        with open(requirements_out, 'r') as file:
            original_contents = file.read()
    except:
        original_contents = None
    
    subprocess.run(["pip-compile", requirements_in, "--output-file", requirements_out], check=True)

    with open(requirements_out, 'r') as file:
        new_contents = file.read()
        
    jupyter_lab_requirements_changed = original_contents == new_contents

    print(f"Updated jupyter-lab requirements successfully (changed = {jupyter_lab_requirements_changed}).")
except Exception as e:
    error_info.append(("JupyterLab", e))
    
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

bump_version = jupyter_lab_requirements_changed

for v in versions_to_check:
    old_version = version.parse(os.getenv(v[0]) if os.getenv(v[0]) else "0.0.0")
    new_version = version.parse(str(v[1]))
    
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
versions = f"""export DEV_CONTAINER_VERSION={debian_codename}-{dev_container_version}
export DEV_CONTAINER_USER={os.getenv('DEV_CONTAINER_USER')}
export DEV_CONTAINER_USER_GROUP={os.getenv('DEV_CONTAINER_USER_GROUP')}
export DEBIAN_CODENAME={debian_codename}
export DEBIAN_VERSION={debian_version}
export DOTNET_VERSION={dotnet_version}
export RUST_VERSION={rust_version}
export NVM_VERSION={nvm_version}
export NODE_VERSION={node_version}
export JDK_VERSION={jdk_version}
export JDK_DOWNLOAD_URL={jdk_download_url}
export MAVEN_VERSION={maven_version}
export MAVEN_DOWNLOAD_URL={maven_download_url}
export GO_VERSION={go_version}
export GO_DOWNLOAD_URL={go_download_url}
export CONAN_VERSION={conan_version}
export CONAN_DOWNLOAD_URL={conan_version_url}
export PHP_VERSION={php_version}
export NGINX_VERSION={nginx_version}
export CODE_SERVER_VERSION={code_server_version}
export CONDA_ENV={os.getenv('CONDA_ENV')}
export PYTHON_VERSION={python_version}
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