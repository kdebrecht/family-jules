#!/usr/bin/env bash

#####
#
#  Setup Node
#
###

if [ -f ".nvmrc" ]; then
  echo "Found .nvmrc file. Installing Node.js version from file..."
  nvm install
  nvm use
else
  echo "No .nvmrc file found. Installing the latest stable version of Node.js..."

fi



node -v

if [ ! -z "${NPM_FULL_INSTALL}" ]; then
    echo "Doing Full NPM Install"
    npm install
else
  echo "Doing NPM Install from Lock File"
    npm ci
fi
