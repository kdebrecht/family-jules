#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e
CP=$(cd "$(dirname "$0")" && pwd)
echo $CP
sleep 5

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_DIR="$PWD"
COMMANDS="${SCRIPT_DIR}"

ENV_FILE=".env"
cp .env.example ${ENV_FILE}
chmod 777 .env

. "$COMMANDS/env-functions.sh"

# --- Configuration Variables ---
DB_DATABASE=$(get_env "DB_DATABASE" "laravel")
DB_HOST=$(get_env "DB_HOST" "pgsql")
TEST_DB_DATABASE=$(get_env "TEST_DB_DATABASE" "testing" )
DB_USERNAME=$(get_env "DB_USERNAME" "sail" )
DB_PASSWORD=$(get_env "DB_PASSWORD" "password" )
PHP_VERSION=$(get_env "PHP_VERSION" "8.4" )


# Host Setup for DB access
echo "127.0.0.1 ${DB_HOST}" | sudo tee -a /etc/hosts


echo "🚀 Starting Laravel environment setup..."

. "${COMMANDS}/mailpit.sh"
. "${COMMANDS}/pgsql.sh"
. "${COMMANDS}/php.sh"
. "${COMMANDS}/nginx.sh"


echo "✅ Setup complete!"
echo "---------------------------------------------------------"


composer install
php artisan key:generate
php artisan migrate
sudo -u postgres psql -d "${DB_DATABASE}" -c "\dt"
sudo -u postgres psql -d "${TEST_DB_DATABASE}" -c "\dt"

show_git_diffs

echo "✅ Laravel complete!"
echo "---------------------------------------------------------"

