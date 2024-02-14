#!/bin/bash
set -e

echo "> Installing PHP"
space_before=$(df --output=avail / | tail -n 1)


echo ">> Installing PHP Requirements"
apt install -y -qq \
	ca-certificates \
	apt-transport-https \
	software-properties-common \
	debian-archive-keyring \
	lsb-release \
	libpng-dev \
	libjpeg-dev \
	libtiff-dev \
	ghostscript \
	imagemagick \
	openssl \
	curl

# Install gpg keys
echo ">> Setting-up PHP and Nginx sources"

curl -fsSLo /etc/apt/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
curl -fsSL "https://nginx.org/keys/nginx_signing.key" | gpg --dearmor --yes -o /etc/apt/keyrings/nginx-archive-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ ${DEBIAN_CODENAME} main" > /etc/apt/sources.list.d/php.list
echo "deb [signed-by=/etc/apt/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/debian ${DEBIAN_CODENAME} nginx" > /etc/apt/sources.list.d/nginx.list

echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | tee /etc/apt/preferences.d/99nginx

# Install php and nginx
echo ">> Installing PHP and Nginx packages"

apt update -qq
apt install -y -qq \
	"nginx" \
	"php${PHP_VERSION}" \
	"php${PHP_VERSION}-cli" \
	"php${PHP_VERSION}-cgi" \
	"php${PHP_VERSION}-fpm" \
	"php${PHP_VERSION}-curl" \
	"php${PHP_VERSION}-mysqlnd" \
	"php${PHP_VERSION}-ftp" \
	"php${PHP_VERSION}-gd" \
	"php${PHP_VERSION}-opcache" \
	"php${PHP_VERSION}-bz2" \
	"php${PHP_VERSION}-zip" \
	"php${PHP_VERSION}-intl" \
	"php${PHP_VERSION}-common" \
	"php${PHP_VERSION}-bcmath" \
	"php${PHP_VERSION}-imagick" \
	"php${PHP_VERSION}-readline" \
	"php${PHP_VERSION}-redis" \
	"php${PHP_VERSION}-mbstring" \
	"php${PHP_VERSION}-apcu" \
	"php${PHP_VERSION}-xml" \
	"php${PHP_VERSION}-dom" \
	"php${PHP_VERSION}-xdebug" \
	"php${PHP_VERSION}-yaml" \
	"php${PHP_VERSION}-pcov" \
	"php${PHP_VERSION}-imap" \
	"php${PHP_VERSION}-mongodb" \
	"php${PHP_VERSION}-smbclient" \
	"php${PHP_VERSION}-sqlite3" \
	"php${PHP_VERSION}-dev" \
	"php${PHP_VERSION}-mbstring"

# Create www folder
echo ">> Create /usr/share/nginx/www folder"
mkdir -p /usr/share/nginx/www

# Replace nginx and php config
echo ">> Copy PHP and Nginx config files"

cp -fv /scripts/languages/php/configuration/nginx/nginx.conf /etc/nginx/nginx.conf
cp -fv /scripts/languages/php/configuration/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

cp -fv /scripts/languages/php/configuration/php.ini "/etc/php/${PHP_VERSION}/fpm/php.ini"
cp -fv /scripts/languages/php/configuration/php-fpm.conf "/etc/php/${PHP_VERSION}/fpm/php-fpm.conf"
cp -fv /scripts/languages/php/configuration/www.conf "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf"

# Add nginx user to www-data group (php-fpm socket access)
echo ">> Add nginx user to www-data group for php-fpm socket access"
usermod -a -G www-data nginx

# Check config
echo ">> Checking Nginx config"
nginx -t

# Remove original html folder and create a php file
echo ">> Remove unused html foder and create php file with phpinfo();"
rm -rf /usr/share/nginx/html
echo "<?php phpinfo(); ?>" > /usr/share/nginx/www/index.php

# Install composer
# See: https://getcomposer.org/download/
echo ">> Install Composer"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"

mv composer.phar /usr/local/bin/composer

# Create link in home directory to www folder
ln -s /home/dev-user/www /usr/share/nginx/www

# Setup services
echo ">> Create PHP-FPM and Nginx services"

echo "[program:nginx]
command=bash -c 'source /etc/profile && exec /usr/sbin/nginx -g \"daemon off;\"'
autostart=true
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

[program:php-fpm]
command=bash -c 'source /etc/profile && exec /usr/sbin/php-fpm${PHP_VERSION} -F --fpm-config /etc/php/${PHP_VERSION}/fpm/php-fpm.conf'
autostart=true
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true

" >> /etc/supervisor/conf.d/supervisord.conf


# Display install size
echo "- Installation completed: PHP and Nginx"
echo "> Space used: $(numfmt --to=iec $(( space_before - $(df --output=avail / | tail -n 1) )))"
