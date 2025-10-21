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