#!/bin/bash

## Copy this file to the Jules System
set -e

run_scripts() {

}


REPO_URL="https://github.com/kdebrecht/family-jules.git"
BRANCH_NAME="alpha"
CLONE_DIR=".family-jules"
SCRIPT_TO_RUN="jules-full-env.sh"
PATH_FILE="family-jules-path.tmp"

echo "🚀 Starting deployment..."

echo "Cloning branch '$BRANCH_NAME' from '$REPO_URL'..."
git clone --branch "$BRANCH_NAME" "$REPO_URL" "$CLONE_DIR"


echo "$PWD/$CLONE_DIR" > $PATH_FILE
echo "✅ Successfully entered repository directory."

# 2. Run the setup script.
# Check if the script exists and is executable before running.
if [ -f "$SCRIPT_TO_RUN" ]; then
  echo "Running setup script: $SCRIPT_TO_RUN..."
  chmod +x "$SCRIPT_TO_RUN"
  ./"$SCRIPT_TO_RUN"
  echo "✅ Script execution completed."
else
  echo "❌ Error: Setup script '$SCRIPT_TO_RUN' not found!"
  # Exit the subshell with an error code.
  exit 1
fi


# 3. Remove the repository directory.
echo "Cleaning up..."
rm -rf "$CLONE_DIR"
rm "$PATH_FILE"

echo "✅ Cleanup complete. Directory '$CLONE_DIR' has been removed."
echo "🎉 Deployment finished successfully!"