from dotenv import load_dotenv 
from bs4 import BeautifulSoup
from packaging import version
from jinja2 import Environment, FileSystemLoader
import traceback
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
    error_info.append(("Debian", e, traceback.format_exc()))
    debian_codename = os.getenv('DEBIAN_CODENAME')
    debian_version = os.getenv('DEBIAN_VERSION')

# Dotnet
try:
    dotnet_packages = requests.get(f"https://packages.microsoft.com/debian/{debian_version}/prod/dists/{debian_codename}/main/binary-amd64/Packages").text
    dotnet_sdk_versions = sorted(re.findall(r'Package: dotnet-sdk-(\d+\.\d+)', dotnet_packages), key=lambda v: version.parse(v), reverse=True)
    dotnet_version = dotnet_sdk_versions[0]
    
    print(f"Retrieved Dotnet SDK version successfully: {dotnet_version}")
except Exception as e:
    error_info.append(("Dotnet", e, traceback.format_exc()))
    dotnet_version = os.getenv('DOTNET_VERSION')

# Rust Stable
try:
    rust_stable_channel = requests.get(f"https://static.rust-lang.org/dist/channel-rust-stable.toml").text
    rust_versions = re.findall(r'version = "(.*?) \(', rust_stable_channel)
    rust_version = max(rust_versions, key=version.parse)
    
    print(f"Retrieved Rust stable version successfully: {rust_version}")
except Exception as e:
    error_info.append(("Rust", e, traceback.format_exc()))
    rust_version = os.getenv('RUST_VERSION')

# NVM Version
try:
    nvm_version = requests.get("https://api.github.com/repos/nvm-sh/nvm/releases/latest").json()['tag_name']
    
    print(f"Retrieved Nvm version successfully: {nvm_version}")
except Exception as e:
    error_info.append(("Nvm", e, traceback.format_exc()))
    nvm_version = os.getenv('NVM_VERSION')

# Node LTS
try:
    node_releases = response = requests.get("https://nodejs.org/dist/index.json").json()
    node_lts_releases = [release['version'].lstrip('v') for release in node_releases if release.get('lts') != False]
    node_version = max(node_lts_releases, key=lambda release: version.parse(release))
    
    print(f"Retrieved Node LTS version successfully: {node_version}")
except Exception as e:
    error_info.append(("Node", e, traceback.format_exc()))
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
    jdk_version = re.search(r"jdk-([\d+\.*]+)", jdk_download_url).group(1)
    
    print(f"Retrieved Java JDK version successfully: {jdk_version}")
    print(f"Retrieved Java JDK download URL successfully: {jdk_download_url}")
except Exception as e:
    error_info.append(("Java JDK", e, traceback.format_exc()))
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
    error_info.append(("Maven", e, traceback.format_exc()))
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
    error_info.append(("Go", e, traceback.format_exc()))
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
    error_info.append(("Php", e, traceback.format_exc()))
    php_version = os.getenv('PHP_VERSION')

# NGinx
try:
    nginx_packages = requests.get(f"https://nginx.org/packages/debian/dists/{debian_codename}/nginx/binary-amd64/Packages").text
    nginx_packages_versions = sorted(re.findall(r'Package: nginx\nVersion: (\d+\.\d+.\d+)', nginx_packages), key=lambda v: version.parse(v), reverse=True)
    nginx_version = nginx_packages_versions[0]
    
    print(f"Retrieved Nginx version successfully: {nginx_version}")
except Exception as e:
    error_info.append(("Nginx", e, traceback.format_exc()))
    nginx_version = os.getenv('NGINX_VERSION')    

# Code Server
try:
    code_server_version = requests.get("https://api.github.com/repos/coder/code-server/releases/latest").json()['tag_name'].lstrip('v')
    
    print(f"Retrieved Code Server version successfully: {code_server_version}")
except Exception as e:
    error_info.append(("Code Server", e, traceback.format_exc()))
    code_server_version = os.getenv('CODE_SERVER_VERSION')

# Python
try:
    python_versions = [pkg_info['version'] for pkg_info in requests.get('https://repo.anaconda.com/pkgs/main/linux-64/repodata.json').json()['packages'].values() if pkg_info['name'] == 'python']
    python_version = max(python_versions, key=version.parse)

    print(f"Retrieved Python version successfully: {python_version}")
except Exception as e:
    error_info.append(("Python", e, traceback.format_exc()))
    python_version = os.getenv('PYTHON_VERSION')

# JupyterLab
def clean_requirements(text):
    # Used to check if requirements.txt changed
    # Remove all lines containing a sharp symbol
    lines = text.split('\n')
    lines_without_sharp = [line for line in lines if '#' not in line]
    
    # Join the remaining lines back together with newline characters
    text_without_sharp = '\n'.join(lines_without_sharp)
    
    # Remove all spaces and unwanted characters, but leave '==', alphanumeric characters, and newlines
    text_cleaned = re.sub(r'(?m)[^\w\n=.]+', '', text_without_sharp)
    
    return text_cleaned

jupyter_lab_requirements_changed = False
try:
    requirements_in = "./scripts/tools/jupyter-lab/requirements-conda-dev.in"
    requirements_out = "./scripts/tools/jupyter-lab/requirements-conda-dev.txt"
    
    with open(requirements_out, 'r') as file:
        original_content = clean_requirements(file.read())
    
    os.remove(requirements_out)
    
    subprocess.run(["pip-compile", requirements_in, "--output-file", requirements_out], check=True)

    with open(requirements_out, 'r') as file:
        new_content = clean_requirements(file.read())
    
    jupyter_lab_requirements_changed = original_content != new_content

    print(f"Updated jupyter-lab requirements successfully (changed = {jupyter_lab_requirements_changed}).")
    
    if jupyter_lab_requirements_changed:
        print(f"Old requirements:\n{original_content}\n\n\n\nNew Requirements :\n{new_content}")
except Exception as e:
    error_info.append(("JupyterLab", e, traceback.format_exc()))
    
# Gophernote Jupyter Kernel Version
try:
    gophernote_version = requests.get("https://api.github.com/repos/gopherdata/gophernotes/releases/latest").json()['tag_name']
    
    print(f"Retrieved Gophernote Jupyter Kernel version successfully: {gophernote_version}")
except Exception as e:
    error_info.append(("Gophernote Jupyter Kernel", e, traceback.format_exc()))
    gophernote_version = os.getenv('GOPHERNOTE_JUPYTER_KERNEL_VERSION')
    
# IJava Jupyter Kernel Version
try:
    ijava_release = requests.get("https://api.github.com/repos/SpencerPark/IJava/releases/latest").json()
    ijava_version = ijava_release['tag_name']
    ijava_download_url = [asset['browser_download_url'] for asset in ijava_release['assets'] if (asset['browser_download_url'] is not None and asset['browser_download_url'].endswith('.zip') and 'ijava' in asset['browser_download_url'])][0]
    
    print(f"Retrieved IJava Jupyter Kernel download URL successfully: {ijava_download_url}")
except Exception as e:
    error_info.append(("IJava Jupyter Kernel", e, traceback.format_exc()))
    ijava_download_url = os.getenv('IJAVA_JUPYTER_KERNEL_DOWNLOAD_URL')

# noVNC Url
try:
    no_vnc_download_url = requests.get("https://api.github.com/repos/novnc/noVNC/releases/latest").json()['tarball_url']
    print(f"Retrieved NoVNC Download URL successfully: {no_vnc_download_url}")
except Exception as e:
    error_info.append(("No VNC Download URL", e, traceback.format_exc()))
    no_vnc_download_url = os.getenv('NO_VNC_DOWNLOAD_URL')

# JetBrains Versions
def render_jinja_template(template_path, context, output_file):
    # Setup Jinja
    template_dir, template_file = os.path.split(template_path)
    env = Environment(loader=FileSystemLoader(template_dir))
    template = env.get_template(template_file)
    
    # Render the template with the provided context
    rendered_content = template.render(context)
    
    # Get Existing Content
    existing_content = None
    if os.path.exists(output_file):
        with open(output_file, 'r') as file:
            existing_content = file.read()
    
    # Write Output
    with open(output_file, 'w') as file:
        file.write(rendered_content)
    
    changed = rendered_content != existing_content
    
    if changed:
        print(f"Jinja output changed: " + output_file)
    
    return changed

jetbrains_changed = False
try:
    jetbrains_products = [
        { 'code': 'PS', 'name': 'PhpStorm', 'icon': 'phpstorm.png', 'bin': 'phpstorm.sh', 'script': 'phpstorm.sh', 'shortname': 'phpstorm', 'description': 'PHP IDE by JetBrains' },
        { 'code': 'DG', 'name': 'DataGrip', 'icon': 'datagrip.png', 'bin': 'datagrip.sh', 'script': 'datagrip.sh', 'shortname': 'datagrip', 'description': 'IDE for Databases & SQL' },
        { 'code': 'GO', 'name': 'GoLand', 'icon': 'goland.png', 'bin': 'goland.sh', 'script': 'goland.sh', 'shortname': 'goland', 'description': 'Go Programming Language IDE' },
        { 'code': 'CL', 'name': 'CLion', 'icon': 'clion.png', 'bin': 'clion.sh', 'script': 'clion.sh', 'shortname': 'clion', 'description': 'IDE for C and C++' },
        { 'code': 'RD', 'name': 'Rider', 'icon': 'rider.png', 'bin': 'rider.sh', 'script': 'rider.sh', 'shortname': 'rider', 'description': '.NET IDE' },
        { 'code': 'IIU', 'name': 'IntelliJ IDEA Ultimate', 'icon': 'idea.png', 'bin': 'idea.sh', 'script': 'idea.sh', 'shortname': 'idea', 'description': 'Java and Kotlin IDE' },
        { 'code': 'IIC', 'name': 'IntelliJ IDEA Community Edition', 'icon': 'idea-ce.png', 'bin': 'idea.sh', 'script': 'idea-ce.sh', 'shortname': 'idea', 'description': 'Java and Kotlin IDE' },
        { 'code': 'PCP', 'name': 'PyCharm Professional Edition', 'icon': 'pycharm.png', 'bin': 'pycharm.sh', 'script': 'pycharm.sh', 'shortname': 'pycharm', 'description': 'Python IDE for data science and web development' },
        { 'code': 'PCC', 'name': 'PyCharm Community Edition', 'icon': 'pycharm-ce.png', 'bin': 'pycharm.sh', 'script': 'pycharm-ce.sh', 'shortname': 'pycharm', 'description': 'Python IDE for data science and web development' },
        { 'code': 'WS', 'name': 'WebStorm', 'icon': 'webstorm.png', 'bin': 'webstorm.sh', 'script': 'webstorm.sh', 'shortname': 'webstorm', 'description': 'JavaScript and TypeScript IDE' },
        { 'code': 'RR', 'name': 'RustRover', 'icon': 'rustrover.png', 'bin': 'rustrover.sh', 'script': 'rustrover.sh', 'shortname': 'rustrover', 'description': 'IDE for Rust developers' }
    ]
    jetbrains_product_codes = ",".join([product['code'] for product in jetbrains_products])
    jetbrains_release_urls = "https://data.services.jetbrains.com/products/releases?code=" + jetbrains_product_codes + "&latest=true&type=release"
    print(f"jetbrains_release_urls={jetbrains_release_urls}")
    jetbrains_releases = requests.get(jetbrains_release_urls).json()
    
    for product in jetbrains_products:
        print('Updating ' + product['name'])
        product['download_url'] = jetbrains_releases[product['code']][0]['downloads']['linux']['link']
        jetbrains_changed |= render_jinja_template('./scripts/tools/jetbrains/templates/install.tpl', product, './scripts/tools/jetbrains/scripts/'+product['script'])
        jetbrains_changed |= render_jinja_template('./scripts/tools/jetbrains/templates/desktop-shortcut.tpl', product, './scripts/tools/jetbrains/shortcuts/jetbrains-'+product['code']+'.desktop')
        
    print(f"Updated JetBrains Versions Sucessfully: (jetbrains_changed={jetbrains_changed}")
except Exception as e:
    error_info.append(("JetBrains Versions", e, traceback.format_exc()))

# Dev Container Version
dev_container_version = version.parse(os.getenv('DEV_CONTAINER_VERSION').split('-')[1] if os.getenv('DEV_CONTAINER_VERSION') else "1.0")
print(f"Current dev container version: {dev_container_version}")

def get_versions():
    return f"""export DEV_CONTAINER_VERSION={debian_codename}-{dev_container_version}
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
export GOPHERNOTE_JUPYTER_KERNEL_VERSION={gophernote_version}
export IJAVA_JUPYTER_KERNEL_DOWNLOAD_URL={ijava_download_url}
export NO_VNC_DOWNLOAD_URL={no_vnc_download_url}
"""
versions = get_versions()

with open(".env", 'r') as file:
    original_content = clean_requirements(file.read())

versions_file_changed = original_content != versions
    
# Check if results changed
print(f"""jupyter_lab_requirements_changed={jupyter_lab_requirements_changed}
jetbrains_changed={jetbrains_changed}
versions_file_changed={versions_file_changed}
""")

bump_version = jupyter_lab_requirements_changed or jetbrains_changed or versions_file_changed

if bump_version:
    major = dev_container_version.major
    minor = dev_container_version.minor + 1
    dev_container_version = f"{major}.{minor}"
    print(f"Version bumped: {dev_container_version} -> {major}.{minor}")
    print(f"New dev container version: {dev_container_version}")
    
# Write dotenv file
dotenv_file = '.env'
if bump_version:
    print('Updating versions')
    versions = get_versions()
    print(versions)
    with open(dotenv_file, 'w') as file:
        file.write(versions)
else:
    print('No change detected')

# Display errors if any
if len(error_info) > 0:
    for e in error_info:
        print(f"Error checking {e[0]} version: {str(e[1])}\r\n{str(e[2])}")
    sys.exit(1)

# Clean exit
sys.exit(0)