#!/usr/bin/env bash

#####
#
#  Setup Node
#
###
nvm install
nvm use

node -v

if [ ! -z "${NPM_FULL_INSTALL}" ]; then
    echo "Doing Full NPM Install"
    npm install
else
  echo "Doing NPM Install from Lock File"
    npm ci
fi
