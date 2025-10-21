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


show_git_diffs() {
    # First, check if there are any changes at all.
    # The '--quiet' flag makes 'git diff-index' exit with a non-zero status if there are changes.
    if git diff-index --quiet HEAD --; then
        echo "No modifications to show. The working directory is clean."
        return
    fi

    # Loop through each file reported as modified by 'git diff'.
    # Using 'git diff --name-only' gives us a clean list of filenames.
    for file in $(git diff --name-only); do
        echo "=================================================="
        echo "📄 Diff for: $file"
        echo "=================================================="
        # Show the diff for the current file.
        # The '--' ensures filenames starting with a dash are handled correctly.
        git diff -- "$file"
        echo # Add a blank line for better spacing between files.
    done

    echo "--- End of Diffs ---"
}
show_git_diffs

echo "✅ Laravel complete!"
echo "---------------------------------------------------------"

