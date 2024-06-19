REM Enable Docker BuildKit
set DOCKER_BUILDKIT=1

REM Build the Docker image with the specified Dockerfile
docker build -t update-version -f update-versions.Dockerfile .

REM Run the Docker container with the necessary volumes mounted
docker run -v "%cd%\.env":/workspace/.env ^
           -v "%cd%\scripts\tools\jupyter-lab/":/workspace/scripts/tools/jupyter-lab/ ^
           -v "%cd%\.github\workflows\update-versions.py":/workspace/update-versions.py ^
           -v "%cd%\scripts\tools\jetbrains/":/workspace/scripts/tools/jetbrains/ ^
           update-version