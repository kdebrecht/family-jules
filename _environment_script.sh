#!/usr/bin/env bash

## Copy this file to the Jules System
set -e

REPO_URL="https://github.com/kdebrecht/family-jules.git"
BRANCH_NAME="alpha"
CLONE_DIR=".family-jules"
INSTALL_SCRIPT="jules-environment.sh"


echo "🚀 Starting deployment..."

echo "Cloning branch '${BRANCH_NAME}' from '${REPO_URL}'..."
git clone --branch "${BRANCH_NAME}" "${REPO_URL}" "${CLONE_DIR}"


SCRIPT_TO_RUN="${CLONE_DIR}/${INSTALL_SCRIPT}"

echo "✅ Successfully entered repository directory."


# 2. Run the setup script.
# Check if the script exists and is executable before running.
if [ -f "${SCRIPT_TO_RUN}" ]; then
  echo "Running setup script: ${SCRIPT_TO_RUN}..."
  chmod +x "${SCRIPT_TO_RUN}"
  . ./"${SCRIPT_TO_RUN}"
  echo "✅ Script execution completed."
else
  echo "❌ Error: Setup script '${SCRIPT_TO_RUN}' not found!"
fi


# 3. Remove the repository directory.
echo "Cleaning up..."
rm -rf "${CLONE_DIR}"

echo "✅ Cleanup complete. Directory '${CLONE_DIR}' has been removed."
echo "🎉 Deployment finished successfully!"