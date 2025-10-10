#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

PROJECT_DIR="$PWD"
PATH_FILE="family-jules-path.tmp"
if [ -f "$PATH_FILE" ]; then
  BASEPATH="$(< $PATH_FILE)"
else
  BASEPATH="$PWD/.family-jules"
fi
COMMANDS="$BASEPATH/commands"

echo "PROJECT_DIR $PWD"
echo "Base Path $BASEPATH"
echo "Commands $COMMANDS"


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

echo "✅ Laravel complete!"
echo "---------------------------------------------------------"

