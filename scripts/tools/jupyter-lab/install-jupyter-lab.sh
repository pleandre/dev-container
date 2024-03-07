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


echo ">> Copying code-server startup scripts"
mkdir -p /opt/dev-container/jupyter/
cp /scripts/tools/jupyter-lab/opt/* /opt/dev-container/jupyter/

# Add Jupyter Lab as supervisord service
echo ">> Add JupyterLab as supervisord service"
echo "[program:jupyterlab]
environment=HOME=\"/home/${DEV_CONTAINER_USER}\"
command=bash -c '/opt/dev-container/jupyter/jupyter-lab-start.sh'
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
su -l $DEV_CONTAINER_USER /bin/bash -c "source /etc/profile && source ~/.miniconda3/bin/activate ${CONDA_ENV} && dotnet tool install --global Microsoft.dotnet-interactive && dotnet interactive jupyter install"

# Add Ansible support: https://github.com/ansible/ansible-jupyter-kernel
echo ">> Add Jupyter Ansible support"
su -l $DEV_CONTAINER_USER /bin/bash -c "source ~/.miniconda3/bin/activate ${CONDA_ENV} && pip install ansible-kernel && python -m ansible_kernel.install"

# Add Bash support: https://github.com/takluyver/bash_kernel
echo ">> Add Jupyter Bash support"
su -l $DEV_CONTAINER_USER /bin/bash -c "source ~/.miniconda3/bin/activate ${CONDA_ENV} && pip install bash_kernel && python -m bash_kernel.install"

# Add C++ support: https://github.com/jupyter-xeus/xeus-cling
echo ">> Add Jupyter C++ support"
su -l $DEV_CONTAINER_USER /bin/bash -c "source ~/.miniconda3/bin/activate ${CONDA_ENV} && conda install xeus-cling -c conda-forge -y"

# Add Javascript Typescript support: https://github.com/yunabe/tslab
echo ">> Add Typescript support"
su -l $DEV_CONTAINER_USER /bin/bash -c ". ~/.nvm/nvm.sh && source ~/.miniconda3/bin/activate ${CONDA_ENV} && npm install -g tslab && tslab install --python=python"

# Add Java support: https://github.com/SpencerPark/IJava
echo ">> Add Java support"
su -l $DEV_CONTAINER_USER /bin/bash -c "source /etc/profile && source ~/.miniconda3/bin/activate ${CONDA_ENV} && curl -L ${IJAVA_JUPYTER_KERNEL_DOWNLOAD_URL} -o /tmp/ijava.zip && unzip -o /tmp/ijava.zip -d /tmp/ijava && python /tmp/ijava/install.py --sys-prefix && rm -rf /tmp/ijava /tmp/ijava.zip"

# Add Go support: https://github.com/gopherdata/gophernotes
echo ">> Add Jupyter Go support"
su -l $DEV_CONTAINER_USER /bin/bash -c "source /etc/profile && source ~/.miniconda3/bin/activate ${CONDA_ENV} && go install github.com/gopherdata/gophernotes@${GOPHERNOTE_JUPYTER_KERNEL_VERSION} && mkdir -p ~/.local/share/jupyter/kernels/gophernotes && cp \${GOPATH}/pkg/mod/github.com/gopherdata/gophernotes@${GOPHERNOTE_JUPYTER_KERNEL_VERSION}/kernel/* ~/.local/share/jupyter/kernels/gophernotes && chmod +w ~/.local/share/jupyter/kernels/gophernotes/kernel.json && sed \"s|gophernotes|\${GOPATH}bin/gophernotes|\" < ~/.local/share/jupyter/kernels/gophernotes/kernel.json.in > ~/.local/share/jupyter/kernels/gophernotes/kernel.json"

# Display install size
echo "- Installation completed: JupyterLab"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / | tail -n 1) )))"
