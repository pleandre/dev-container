# dev-container
[![GitHub Repo](https://img.shields.io/badge/GitHub-Repo-blue?style=flat&logo=github)](https://github.com/pleandre/dev-container/)
[![Build And Tests](https://github.com/pleandre/dev-container/actions/workflows/build-publish.yml/badge.svg)](https://github.com/pleandre/dev-container/actions/workflows/build-publish.yml)
[![Versions Update](https://github.com/pleandre/dev-container/actions/workflows/update-versions.yml/badge.svg)](https://github.com/pleandre/dev-container/actions/workflows/update-versions.yml)
[![Docker Hub](https://img.shields.io/docker/image-size/pleandre/dev-container/latest?style=flat&logo=docker)](https://hub.docker.com/r/pleandre/dev-container/)
[![Docker Stars](https://img.shields.io/docker/stars/pleandre/dev-container.svg?style=flat&logo=docker)](https://hub.docker.com/r/pleandre/dev-container/)
[![Docker Pulls](https://img.shields.io/docker/pulls/pleandre/dev-container.svg?style=flat&logo=docker)](https://hub.docker.com/r/pleandre/dev-container/)
[![License](https://img.shields.io/github/license/pleandre/dev-container.svg?style=flat)](https://github.com/pleandre/dev-container/blob/main/LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/pleandre/dev-container.svg?style=flat)](https://github.com/pleandre/dev-container/commits/main)
[![Code Size](https://img.shields.io/github/languages/code-size/pleandre/dev-container.svg?style=flat)](https://github.com/pleandre/dev-container)

A comprehensive, multi-language development environment in a container, featuring code-server, JupyterLab, and a suite of development tools.  

## Quick Start with docker-compose
To get started quickly, you can use `docker-compose` to run the container. First, create a `data` directory with the following subdirectories to persist your configuration and extensions:
- `.config`
- `extensions`

Here is the `docker-compose.yml` configuration:

```yaml
version: '3.8'

services:
  coder:
    image: pleandre/dev-container
    container_name: coder
    restart: always
    ports:
      - "8080:8080"  # Port exposed by Code Server
      - "3000:3000"  # Port for web apps like React with auto-reload
      - "81:81"      # Port for Nginx / PHP
      - "80:80"      # Port for APIs
      - "8888:8888"  # Port for Jupyter
#    volumes:
#      - "/var/run/docker.sock:/var/run/docker.sock"  # Optional, Socket for Docker, if you want to have access to your host docker within the dev container
#      - "./settings/code-server-vscode-marketplace.json:/opt/dev-container/code-server/marketplace.json" # Optional, code server extension market place settings
#      - "./settings/extensions.json:/opt/dev-container/code-server/extensions.json" # Optional, to install extensions at startup
#      - "./www:/usr/share/nginx/www" # Optional, php server root directory
#      - "./projects:/home/dev-user/projects/" # Optional, projects directory
#      - "./jupyter:/home/dev-user/jupyter/" # Optional, jupyter directory
```  

You can also mount your Git repository or other folders.  
  
If you don't need any persistence or don't need to run Docker inside Docker, or to test the container, you can run the following command:  
```bash
docker run -d --name dev-container -p 8080:8080 -p 3000:3000 -p 81:81 -p 80:80 -p 8888:8888 pleandre/dev-container
```  
Make sure to change the ports and volume paths according to your needs. The `docker run` command is provided for a quick start without persistent storage.

## Supported Programming Languages

The `dev-container` supports a diverse array of programming languages for various development needs:

- [Python](https://www.python.org/)
- [Go](https://go.dev/)
- C and C++
- [Rust](https://www.rust-lang.org/)
- [C# (.NET)](https://dotnet.microsoft.com/en-us/download)
- [JavaScript / Node.js](https://nodejs.org/en)
- [Java](https://openjdk.java.net/)
- [PHP](https://www.php.net/)

## Development Tools in dev-container

The `dev-container` is equipped with a comprehensive suite of development, cloud, and infrastructure management tools:

- [Code Server](https://github.com/cdr/code-server) (VS Code in the Browser)
- [JupyterLab](https://jupyter.org/) (Interactive Development Environment)
- [Debian](https://www.debian.org/) (Operating System Base)
- [NVM](https://github.com/nvm-sh/nvm) (Node Version Manager)
- [Maven](https://maven.apache.org/) (Java Package Manager)
- [Gradle](https://gradle.org/) (Java Package Manager)
- [SdkMan](https://sdkman.io/) (SDK Man for Java development)
- [Conan](https://conan.io/) (C/C++ Package Manager)
- [Composer](https://getcomposer.org/) (Php Dependency Manager)
- [Vcpkg](https://github.com/microsoft/vcpkg) (C/C++ Package Manager)
- [Nginx](https://nginx.org/) (Web Server)
- [Conda](https://docs.conda.io/en/latest/) (Python, Package, Dependency, and Environment Management)
- [AWS CLI](https://aws.amazon.com/cli/) (Amazon Web Services Command Line Interface)
- [Google Cloud SDK](https://cloud.google.com/sdk) (Toolset for Google Cloud Platform)
- [1Password CLI](https://developer.1password.com/docs/cli) (Command Line Interface for 1Password)
- [Terraform](https://www.terraform.io/) (Infrastructure as Code Software Tool)
- [Ansible](https://www.ansible.com/) (Software Provisioning, Configuration Management, and Application Deployment Tool)
- [Docker Client](https://docs.docker.com/engine/reference/commandline/cli/) (Command Line Interface for Docker Containers)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/) (Kubernetes Command-Line Tool)

## Versions Auto-Updates

Our project prioritizes keeping dependencies current through an automated update mechanism that runs daily. This ensures that our development environment is consistently aligned with the newest versions of tools and libraries. The process is orchestrated by a GitHub Actions workflow, complemented by a Python script:  
- [update-versions.yml](./.github/workflows/update-versions.yml) - A GitHub Actions workflow that initiates the version update routine.
- [update-versions.py](./.github/workflows/update-versions.py) - The script responsible for executing the version updates.

Additionally, we maintain the robustness of our environment with automated testing:  
- [test.yml](./.github/workflows/test.yml) -  This GitHub Action is triggered on every pull request to run our suite of tests.
- [run-tests.sh](./tests/run-tests.sh) - A script that automates the testing process, ensuring all components are correctly installed and configured.

Our objective is to provide a development environment that's always equipped with the latest tooling.  
This approach is ideal for developers looking to jumpstart new projects in any of the supported languages, with the confidence that they're working with the most up-to-date versions available.  

## Contributing

We warmly welcome contributions to the dev-container! Your insights and improvements help us build a more robust and versatile development environment.  
Here’s how you could contribute:  
 - **VS Code Extensions**: Install essential VS Code extensions for supported programming languages to enhance the developer experience.
 - **Language Support**: Expand language support to include additional programming languages such as Kotlin, Scala, Ruby, R, and Julia.
 - **Development Tools**: Integrate commonly-used development tools that can benefit the majority of users.
 - **Network Configuration**: Implement support for custom CA certificates and corporate network infrastructure such as proxies and private repositories (Nexus, Artifactory, etc.).
 - **Sample Projects**: Create simple starter projects for each supported language to provide quick and practical examples.
 - **Installation Scripts**: Adapt the installation scripts and documentation for use outside the container, aiding those who wish to apply a similar environment setup on their local machines.
 - **Security Improvements**: Strengthen security measures, such as configuring NGINX proxy with authentication in front of services, provide detailed documentation on setting up a reverse proxy for enhanced security or security recommendations.
 - **CI/CD Enhancements**: Improve the Continuous Integration/Continuous Deployment pipeline to refine the auto-update process, version tagging, and change logs.
 - **Image Size Optimization**: Optimize container image size to ensure quicker download times and lower resource consumption without compromising functionality.
 - **Testing**: Broaden the test suite to encompass a wider array of use cases, thereby confirming the environment's reliability.
 - **Documentation**: Refine the documentation to ensure the project is user-friendly and accessible to new contributors.  
And more..  
  
  
Feel free to fork the repository, make your changes, and submit a pull request with your improvements. Your input is valuable to the community!  
  
**To get started:**
1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a pull request outlining the changes you've made.  
  
We appreciate your contributions and are excited to see what you bring to the project.  
  