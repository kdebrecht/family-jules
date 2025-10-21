#!/usr/bin/env bash

echo "DB: ${DB_DATABASE}"
echo "PASSWORD: ${DB_PASSWORD}"
echo "TEST DB: ${TEST_DB_DATABASE}"
echo "DB_USERNAME: ${DB_USERNAME}"

echo "DB: ${DB_DATABASE}" >> jules.log
echo "PASSWORD: ${DB_PASSWORD}" >> jules.log
echo "TEST DB: ${TEST_DB_DATABASE}" >> jules.log
echo "DB_USERNAME: ${DB_USERNAME}" >> jules.log


#  Install and Configure PostgreSQL 17
echo "Installing PostgreSQL 17..."
sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql-17
sudo systemctl enable postgresql
sudo systemctl start postgresql
echo "Configuring PostgreSQL database and user..."
sudo -u postgres psql -c "CREATE DATABASE ${DB_DATABASE};"
sudo -u postgres psql -c "CREATE USER ${DB_USERNAME} WITH PASSWORD '${DB_PASSWORD}';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ${DB_DATABASE} TO ${DB_USERNAME};"
sudo -u postgres psql -c "ALTER USER ${DB_USERNAME} CREATEDB;" # Allows user to create test database
sudo -u postgres psql -c "CREATE DATABASE ${TEST_DB_DATABASE};"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ${TEST_DB_DATABASE} TO ${DB_USERNAME};"
sudo -u postgres psql -d "${DB_DATABASE}" -c "GRANT CREATE ON SCHEMA public TO ${DB_USERNAME};"
sudo -u postgres psql -d "${TEST_DB_DATABASE}" -c "GRANT CREATE ON SCHEMA public TO ${DB_USERNAME};"

