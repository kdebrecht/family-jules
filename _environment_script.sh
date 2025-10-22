#!/usr/bin/env bash

## Copy this file to the Jules System

REPO_URL="https://github.com/kdebrecht/family-jules.git"
BRANCH_NAME="alpha"
CLONE_DIR=".family-jules"
INSTALL_SCRIPT="jules-environment.sh"
SCRIPT_TO_RUN="${CLONE_DIR}/${INSTALL_SCRIPT}"

git clone --branch "${BRANCH_NAME}" "${REPO_URL}" "${CLONE_DIR}"

. ./"${SCRIPT_TO_RUN}"

rm -rf "${CLONE_DIR}"

# Reset Back
# echo "If you have files that are modified you should address them in the install, but a last ditch simple answer is:"
# git reset --hard


echo "🎉 Deployment finished successfully!"