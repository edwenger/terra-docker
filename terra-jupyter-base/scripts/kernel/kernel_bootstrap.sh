#!/usr/bin/env bash

# This script runs at kernel startup time and sets environment variables for the
# workspace name and workspace bucket.
#
# Note: this script is highly dependent on a convention used by Terra and AllOfUs
# applications to place notebooks in the following directory structure:
#
#   ~jupyter-user/<workspace-name>/<mode>/notebook.ipynb
#
# It exploits the fact that the CWD of a launching notebook is named after the workspace.
# If notebooks are ever launched from other directories, this script will break.

# The workspace name is simply the CWD of the running notebook.
PWD="$(pwd)"
export WORKSPACE_NAME=`basename "$(dirname $(pwd)")`

exec "$@"
