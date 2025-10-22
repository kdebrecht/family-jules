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

NPM_FULL_INSTALL=0 #(1=npm install, 0=npm ci)
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

if [-f "jules.log"]; then
  cat "jules.log"
  git restore jules.log
fi

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

WGET_ERROR=

### 3
# Test Env
wget -q -O- http://localhost || WGET_ERROR="WGET Failed"

if [ -n "$WGET_ERROR" ]; then
  cat storage/logs/laravel.log
  echo "$WGET_ERROR" >&2
  exit 1;
fi

