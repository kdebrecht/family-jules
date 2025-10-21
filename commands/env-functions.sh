#!/usr/bin/env bash


get_env() {
    local key="$1"
    local default_value="$2"
    local value
    local env=${ENV_FILE:-".env"}

    # Check if the .env file exists. If not, return the default value.
    if [ ! -f "${ENV_FILE}" ]; then
        echo "$default_value"
        return
    fi

    # Search for the key, extract the value, and remove surrounding quotes.
    value=$(grep "^${key}=" "${ENV_FILE}" | cut -d '=' -f 2- | sed -e "s/^'//" -e "s/'$//" -e 's/^"//' -e 's/"$//')


    # Return the found value. If the value is empty, return the default.
    echo "${value:-$default_value}"
}

echo_log() {
  echo "$@" | sudo tee -a jules.log
}


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