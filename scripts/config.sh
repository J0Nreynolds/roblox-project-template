#!/bin/sh

# Configuration helper for project scripts
# Sources project.config and provides default values

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load project configuration
CONFIG_FILE="$PROJECT_ROOT/project.env"
if [ -f "$CONFIG_FILE" ]; then
    # Simply source the config file if it exists
    set -a 
    . "$CONFIG_FILE"
    set +a
fi

# Set defaults if not configured
PROJECT_NAME=${PROJECT_NAME:-"RobloxProjectTemplate"}

# Helper function to get project name
get_project_name() {
    echo "$PROJECT_NAME"
}

# Helper function to get production place file name
get_production_place_file() {
    echo "${PROJECT_NAME}.rbxl"
}

# Helper function to get test place file name
get_test_place_file() {
    echo "${PROJECT_NAME}_Test.rbxl"
}