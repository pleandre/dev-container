#!/bin/bash
set -e

# Install Ajenti
# See: https://docs.ajenti.org/en/latest/man/install.html#installing
# See: https://github.com/ajenti/ajenti/blob/master/scripts/install.sh
echo "> Install Ajenti"
space_before=$(df --output=avail / --block-size=1 | tail -n 1)

apt install -y -qq build-essential python3-venv python3-pip python3-dev python3-lxml libssl-dev python3-dbus python3-augeas python3-apt ntpdate

mkdir -p /opt/ajenti
python3 -m venv /opt/ajenti/
source /opt/ajenti/bin/activate
/opt/ajenti/bin/pip3 install setuptools pip wheel -U

/opt/ajenti/bin/pip3 install \
	ajenti-panel \
	ajenti.plugin.core \
	ajenti.plugin.dashboard \
	ajenti.plugin.plugins \
	ajenti.plugin.notepad \
	ajenti.plugin.terminal \
	ajenti.plugin.filemanager \
	ajenti.plugin.filesystem \
	ajenti.plugin.services \
	ajenti.plugin.ace \
	ajenti.plugin.augeas \
	ajenti.plugin.datetime \
	ajenti.plugin.passwd \
	ajenti.plugin.docker \
	ajenti.plugin.cron \
	ajenti.plugin.supervisor


#	ajenti.plugin.power \
#	ajenti.plugin.packages \
#	ajenti.plugin.auth-users \
#	ajenti.plugin.fstab \
#	ajenti.plugin.network \
#	ajenti.plugin.check-certificates \
#	ajenti.plugin.traffic \
#	ajenti.plugin.softraid \

# ajenti.plugin.core: main plugin, manages authentication, user environment setup, session, web server, sidebar entries, error handling, etc.
# ajenti.plugin.dashboard: default landing page after successfully authenticate.
# ajenti.plugin.plugins: manage all plugins and their versions.
# ajenti.plugin.notepad: text editor based on Ace code editor.
# ajenti.plugin.terminal: terminal access on the server.
# ajenti.plugin.filemanager: let you navigate on the server filesystem and perform all common operations on files and directories. Uses api of ajenti.plugin.filesystem
# ajenti.plugin.filesystem ajenti.plugin.filesystem: to manage files, directories, upload, ... on the filesystem
# ajenti.plugin.packages: manage the packages installed on your server (apt and pip)
# ajenti.plugin.services: services shows the status of services in systemd or in system V init
# ajenti.plugin.ace: ACE code editor integration
# ajenti.plugin.augeas: query and edit config files
# ajenti.plugin.auth-users: by default ajenti uses allows all users of the system to log in. auth_users provides an alternative way to authenticate users. All users data are stored in plain text, in /etc/ajenti/users.yml.
# ajenti.plugin.datetime: displays the current time zone used, and time and date set on the server.
# ajenti.plugin.fstab: shows mounted drives.
# ajenti.plugin.network: See network interface, dns management, hosts entries.
# ajenti.plugin.passwd: A User DB API plugin for Ajenti panel. Manage user and passwords stored in /etc/shadow.
# ajenti.plugin.power: Uptime appears, you can also reboot or shutdown the server.
# ajenti.plugin.docker: This plugin allows to show all running containers and images.
# ajenti.plugin.cron: Handle all entries in a personal cron file.
# ajenti.plugin.check-certificates: look if your SSL certificates are still valid or not.
# ajenti.plugin.supervisor: handle supervisor services
# ajenti.plugin.traffic: Displays I/O stats for all network interfaces (on dashboard)
# ajenti.plugin.softraid: Read and parse the content of /proc/mdstat in order to show the details on the frontend.

echo ">> Copying ajenti startup scripts"
mkdir -p /opt/dev-container/ajenti/
cp /scripts/tools/ajenti/opt/* /opt/dev-container/ajenti/

echo ">> Add Ajenti as supervisord service"
echo "[program:ajenti]
command=bash -c '/opt/dev-container/ajenti/ajenti-start.sh'
directory=/home/
user=root
autostart=true
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

" >> /etc/supervisor/conf.d/supervisord.conf

# Display install size
echo "- Installation completed: Ajenti"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / --block-size=1 | tail -n 1) )))"