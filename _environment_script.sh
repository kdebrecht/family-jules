#!/usr/bin/env bash

## Copy this file to the Jules System
set -e

REPO_URL="https://github.com/kdebrecht/family-jules.git"
BRANCH_NAME="alpha"
CLONE_DIR=".family-jules"
INSTALL_SCRIPT="jules-environment.sh"
SCRIPT_TO_RUN="${CLONE_DIR}/${INSTALL_SCRIPT}"

git clone --branch "${BRANCH_NAME}" "${REPO_URL}" "${CLONE_DIR}"

. ./"${SCRIPT_TO_RUN}"

rm -rf "${CLONE_DIR}"

echo "🎉 Deployment finished successfully!"