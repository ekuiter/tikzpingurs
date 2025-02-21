#!/usr/bin/env bash

set -e # exit on error

help() {
    echo "usage: $(basename "$0") [command [option]...]"
    echo
    echo "command (default: run)"
    echo "  run"
}

TOOL=tikzpingurs
SCRIPTS_DIRECTORY=$(dirname "$0")
source "$SCRIPTS_DIRECTORY/bootstrap.sh"
source-script "$SCRIPTS_DIRECTORY/functions.sh"

initialize "$@"