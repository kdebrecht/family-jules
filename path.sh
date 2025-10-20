#!/usr/bin/env bash

PROJECT_DIR="$PWD"
PATH_FILE="family-jules-path.tmp"

if [ -f "$PATH_FILE" ]; then
  BASEPATH="$(< $PATH_FILE)"
else
  BASEPATH="$PWD/.family-jules"
fi
COMMANDS="$BASEPATH/commands"

echo "PROJECT_DIR $PWD"
echo "Base Path $BASEPATH"
echo "Commands $COMMANDS"
