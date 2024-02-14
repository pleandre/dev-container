#!/bin/bash
set -e

# Install Jupyterlab
echo "> Installing JupyterLab"
space_before=$(df --output=avail / | tail -n 1)

su -l $DEV_CONTAINER_USER /bin/bash -c "source ~/.miniconda3/bin/activate ${CONDA_ENV} && pip install -r /scripts/tools/jupyter-lab/requirements-conda-dev.txt"

# Install Language Servers
# See: https://jupyterlab-lsp.readthedocs.io/en/latest/Language%20Servers.html
echo ">> Installing Language Servers"
su -l $DEV_CONTAINER_USER /bin/bash -c ". ~/.nvm/nvm.sh && npm install -g dockerfile-language-server-nodejs"
su -l $DEV_CONTAINER_USER /bin/bash -c ". ~/.nvm/nvm.sh && npm install -g bash-language-server"
su -l $DEV_CONTAINER_USER /bin/bash -c ". ~/.nvm/nvm.sh && npm install -g yaml-language-server"
su -l $DEV_CONTAINER_USER /bin/bash -c ". ~/.nvm/nvm.sh && npm install -g typescript-language-server typescript"

# Create jupyter folder in user home
echo ">> Creating jupyter folder in user home"
su -l $DEV_CONTAINER_USER /bin/bash -c "mkdir -p /home/$DEV_CONTAINER_USER/jupyter/"

# Add Jupyter Lab as supervisord service
echo ">> Add JupyterLab as supervisord service"
echo "[program:jupyterlab]
environment=HOME=\"/home/${DEV_CONTAINER_USER}\"
command=bash -c 'source /etc/profile && exec /home/dev-user/.miniconda3/envs/dev/bin/jupyter-lab --ip 0.0.0.0 --NotebookApp.token='' --NotebookApp.password='' --port 8888 --no-browser'
directory=/home/${DEV_CONTAINER_USER}/jupyter
user=${DEV_CONTAINER_USER}
autostart=true
autorestart=true
; Logs to container output
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true
; stdout_logfile=/path/to/coder/logs.log

" >> /etc/supervisor/conf.d/supervisord.conf

# Add C# Support: https://github.com/dotnet/interactive/
echo ">> Add Jupyter C# support"
echo "export DOTNET_INTERACTIVE_CLI_TELEMETRY_OPTOUT=1
export DOTNET_INTERACTIVE_SKIP_FIRST_TIME_EXPERIENCE=true" > /etc/profile.d/dotnet-interactive-env.sh
source /etc/profile.d/dotnet-interactive-env.sh
dotnet tool install --global Microsoft.dotnet-interactive
dotnet interactive jupyter install

# Add Ansible support: https://github.com/ansible/ansible-jupyter-kernel
echo ">> Add Jupyter Ansible support"
su -l $DEV_CONTAINER_USER /bin/bash -c "source ~/.miniconda3/bin/activate ${CONDA_ENV} && pip install ansible-kernel && python -m ansible_kernel.install"

# Add Bash support: https://github.com/takluyver/bash_kernel
echo ">> Add Jupyter Bash support"
su -l $DEV_CONTAINER_USER /bin/bash -c "source ~/.miniconda3/bin/activate ${CONDA_ENV} && pip install bash_kernel && python -m bash_kernel.install"

# Add C++ support: https://github.com/jupyter-xeus/xeus-cling
echo ">> Add Jupyter C++ support"
su -l $DEV_CONTAINER_USER /bin/bash -c "source ~/.miniconda3/bin/activate ${CONDA_ENV} && conda install xeus-cling -c conda-forge"

# Add Go support: https://github.com/gopherdata/gophernotes
echo ">> Add Jupyter Go support"
su -l $DEV_CONTAINER_USER /bin/bash -c "go install github.com/gopherdata/gophernotes@v0.7.5 && mkdir -p ~/.local/share/jupyter/kernels/gophernotes && cd ~/.local/share/jupyter/kernels/gophernotes &&  cp \"$(go env GOPATH)\"/pkg/mod/github.com/gopherdata/gophernotes@v0.7.5/kernel/*  \".\" && chmod +w ./kernel.json && sed \"s|gophernotes|$(go env GOPATH)/bin/gophernotes|\" < kernel.json.in > kernel.json"

# Add Javascript support: https://github.com/n-riesco/ijavascript?tab=readme-ov-file#installation
echo ">> Add Jupyter Javascript support"
su -l $DEV_CONTAINER_USER /bin/bash -c ". ~/.nvm/nvm.sh && npm install -g ijavascript && ijsinstall"

# Add Typescript support: https://github.com/yunabe/tslab
echo ">> Add Typescript support"
su -l $DEV_CONTAINER_USER /bin/bash -c ". ~/.nvm/nvm.sh && npm install -g tslab && tslab install"

# Add Java support: https://github.com/SpencerPark/IJava
echo ">> Add Java support"
su -l $DEV_CONTAINER_USER /bin/bash -c "curl -L https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip -o /tmp/ijava.zip && unzip -o /tmp/ijava.zip -d /tmp/ijava && python /tmp/ijava/install.py --sys-prefix && rm -rf /tmp/ijava /tmp/ijava.zip"

# Display install size
echo "- Installation completed: JupyterLab"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / | tail -n 1) )))"
