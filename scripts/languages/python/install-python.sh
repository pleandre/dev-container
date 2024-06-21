#!/bin/bash
set -e

# Install Miniconda
echo "> Installing Miniconda"
space_before=$(df --output=avail / --block-size=1 | tail -n 1)

space_before_cmd=$(df --output=avail / --block-size=1 | tail -n 1)
su -l $DEV_CONTAINER_USER /bin/bash -c "mkdir -p ~/.miniconda3"
su -l $DEV_CONTAINER_USER /bin/bash -c "wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O  ~/.miniconda3/miniconda.sh"
su -l $DEV_CONTAINER_USER /bin/bash -c "/bin/bash ~/.miniconda3/miniconda.sh -b -u -p ~/.miniconda3"
rm -rf ~/.miniconda3/miniconda.sh
su -l $DEV_CONTAINER_USER /bin/bash -c "~/.miniconda3/bin/conda init bash"
echo ">> Setup latest miniconda.sh: $(numfmt --to=iec $(( space_before_cmd - $(df --output=avail / --block-size=1 | tail -n 1) )))"

# Create conda environment with python version
echo ">> Creating Conda environment with Python version"
space_before_cmd=$(df --output=avail / --block-size=1 | tail -n 1)
su -l $DEV_CONTAINER_USER /bin/bash -c "source ~/.miniconda3/bin/activate base && conda create -n ${CONDA_ENV} python=${PYTHON_VERSION} -y"
su -l $DEV_CONTAINER_USER /bin/bash -c "source ~/.miniconda3/bin/activate ${CONDA_ENV} && conda install -n ${CONDA_ENV} pip -y"
echo ">> Created Python Environment: $(numfmt --to=iec $(( space_before_cmd - $(df --output=avail / --block-size=1 | tail -n 1) )))"

# Activate this environment by default
echo ">> Setup conda default environment"
echo "if [ -f ~/.miniconda3/bin/activate ]; then
	source ~/.miniconda3/bin/activate ${CONDA_ENV}
fi" > /etc/profile.d/conda-env.sh

chmod +x /etc/profile.d/conda-env.sh

# Install pip-tools
echo ">> Install pip-tools"
space_before_cmd=$(df --output=avail / --block-size=1 | tail -n 1)
su -l $DEV_CONTAINER_USER /bin/bash -c "source ~/.miniconda3/bin/activate ${CONDA_ENV} && pip install pip-tools"
echo ">> Installed Pip Tools: $(numfmt --to=iec $(( space_before_cmd - $(df --output=avail / --block-size=1 | tail -n 1) )))"

# Setup Environment Variables
echo ">> Copy Python environment variables"
cp /scripts/languages/python/python-env.sh /etc/profile.d/python-env.sh

# Display install size
echo "- Installation completed: Conda, Python, Pip Tools"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / --block-size=1 | tail -n 1) )))"
