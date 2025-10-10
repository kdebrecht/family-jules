#!/bin/bash

## -----------------------------------------------------------------------------
## This script sets up a Laravel project in an environment without persistent
## shell profiles (like .bashrc). It creates a system-wide 'sail' command.
##
## PREREQUISITES:
## 1. Docker PAT must be in an environment variable named "DOCKER_PAT".
## -----------------------------------------------------------------------------

set -e # Exit immediately if a command exits with a non-zero status.
sudo apt-get update && sudo apt-get install -y acl
#echo "### Step 1: Starting Docker, Setting Permissions & Logging In ###"
git config core.fileMode false

cp .env.example .env
chmod 777 .env

# Set permissions for the folder and its current contents
sudo setfacl -R -m u::rwx,g::rwx,o::rwx $PWD

# Set default permissions for any new files/folders created inside
sudo setfacl -d -m u::rwx,g::rwx,o::rwx $PWD

mkdir "node_modules"

sudo systemctl start docker
# This block ensures the Docker service is running and you are authenticated.
sudo usermod -aG docker $USER
echo "$DOCKER_PAT" | sudo docker login -u kdebrecht --password-stdin
sudo systemctl status docker

WWWUSER=$(id -u)
WWWGROUP=$(id -g)

# NOTE: The 'usermod' change requires a new login to take full effect for
# interactive commands, but the script will proceed correctly.

echo "### Step 2: Setting Up Environment File ###"
if [ -f ".env.example" ]; then
  cp .env.example .env
else
  echo "WARNING: .env.example not found. Skipping .env creation."
fi

echo "### Step 3: Installing PHP Dependencies (via Docker) ###"
sudo docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v "$(pwd)":/var/www/html \
    -w /var/www/html \
    laravelsail/php84-composer:latest \
    composer install --ignore-platform-reqs


echo "### Step 4: Creating a Global 'sail' Command ###"
sudo ln -sf "$(pwd)/vendor/bin/sail" /usr/local/bin/sail


echo "### Step 5: Starting Laravel Sail ###"
sudo sail up -d
sleep 10
echo "### Step 6: Final Application Setup (via Sail) ###"
sudo sail artisan key:generate
sudo sail artisan migrate

echo "### Step 7: Installing Node Dependencies & Building Assets ###"
sudo sail npm ci
sudo sail npm run build

echo "### Step 8: Verifying the Build ###"
wget -qO- http://localhost/

echo "✅ Setup complete! The 'sail' command is now available system-wide."
