#!/bin/sh

set -e

# If Packages aren't installed, install them.
if [ ! -d "Packages" ]; then
    sh scripts/install-packages.sh
fi

# Clean and create dist directory
rm -rf dist/

# Generate sourcemap for src/
rojo sourcemap default.project.json -o sourcemap.json

# Process files from src/ to dist/
ROBLOX_DEV=false darklua process --config .darklua.json src/ dist/

# Build final project from dist/
rojo build build.project.json -o RobloxProjectTemplate.rbxl
