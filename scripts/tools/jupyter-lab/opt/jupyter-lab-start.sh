#!/bin/bash

# Load environment variables
source /etc/profile

# Load nvm
. ~/.nvm/nvm.sh

# Set default values for jupyter args and parameters
export JUPYTERLAB_TOKEN=${JUPYTERLAB_TOKEN:-''}
export JUPYTERLAB_PASSWORD=${JUPYTERLAB_PASSWORD:-''}
export JUPYTERLAB_PORT=${JUPYTERLAB_PORT:-8888}
export JUPYTERLAB_PROJECTS_DIRECTORIES=${JUPYTERLAB_DIR:-$HOME/jupyter/}
export JUPYTERLAB_EXTRA_ARGS=${JUPYTERLAB_EXTRA_ARGS:---log-level='WARN'}

# Script ends and is replaced by jupyterlab process from dev conda environment (exec).
cd $JUPYTERLAB_PROJECTS_DIRECTORIES
exec /home/dev-user/.miniconda3/envs/dev/bin/jupyter-lab --ip 0.0.0.0 --IdentityProvider.token=$JUPYTERLAB_TOKEN --ServerApp.password=$JUPYTERLAB_PASSWORD --port $JUPYTERLAB_PORT --no-browser $JUPYTERLAB_EXTRA_ARGS
