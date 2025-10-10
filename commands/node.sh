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
    echo "Doing Full Install"
    npm install
else
    npm ci
fi
