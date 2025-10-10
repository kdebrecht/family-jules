#!/usr/bin/env bash

# System Update & Essential Packages
echo "Updating system packages..."
sudo apt-get update
#apt-get upgrade -y
sudo apt-get install -y software-properties-common curl git unzip

# 2. Install PHP and Required Extensions
echo "Installing PHP ${PHP_VERSION}..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update
sudo apt-get install -y \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-pgsql \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-tokenizer \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-xdebug

# 3. Install Composer
echo "Installing Composer..."
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

