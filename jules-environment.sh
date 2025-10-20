#!/usr/bin/env bash
##########
#
# Actual Environment setup script to be pasted into Jules
#

SCRIPT_DIR=$PWD/${CLONE_DIR}
COMMANDS="${SCRIPT_DIR}/commands"

. "$COMMANDS/permissions.sh"

### 1
# Setup Node
#
NPM_FULL_INSTALL=1
. "$COMMANDS/node.sh"


### 1
# Full Environment
#
sudo -E bash "$COMMANDS/jules-full-install.sh"


### 2
# npm needs to run as current user, and after composer
#
npm run build

if [ ! -z "${NPM_FULL_INSTALL}" ]; then
    git restore package-lock.json
fi

### 3
# Test Env
wget -O- http://localhost || cat storage/logs/laravel.log


