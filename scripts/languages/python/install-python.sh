#!/bin/bash
set -e

# Install Miniconda
echo "> Installing Miniconda"
space_before=$(df --output=avail / | tail -n 1)

su -l $DEV_CONTAINER_USER /bin/bash -c "mkdir -p ~/.miniconda3"
su -l $DEV_CONTAINER_USER /bin/bash -c "wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O  ~/.miniconda3/miniconda.sh"
su -l $DEV_CONTAINER_USER /bin/bash -c "/bin/bash ~/.miniconda3/miniconda.sh -b -u -p ~/.miniconda3"
rm -rf ~/.miniconda3/miniconda.sh
su -l $DEV_CONTAINER_USER /bin/bash -c "~/.miniconda3/bin/conda init bash"

# Create conda environment with python version
echo ">> Creating Conda environment with Python version"
su -l $DEV_CONTAINER_USER /bin/bash -c "source ~/.miniconda3/bin/activate base && conda create -n ${CONDA_ENV} python=${PYTHON_VERSION} -y"
su -l $DEV_CONTAINER_USER /bin/bash -c "source ~/.miniconda3/bin/activate ${CONDA_ENV} && conda install -n ${CONDA_ENV} pip -y"

# Install pip-tools
echo ">> Install pip-tools"
su -l $DEV_CONTAINER_USER /bin/bash -c "source ~/.miniconda3/bin/activate ${CONDA_ENV} && pip install pip-tools"

# Setup Environment Variables
echo ">> Copy Python environment variables"
cp /scripts/languages/python/python-env.sh /etc/profile.d/python-env.sh

# Display install size
echo "- Installation completed: Conda, Python, Pip Tools"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / | tail -n 1) )))"
