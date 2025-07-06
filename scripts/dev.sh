#!/bin/sh

set -e

# If Packages aren't installed, install them.
if [ ! -d "Packages" ]; then
    sh scripts/install-packages.sh
fi

# Initial setup: copy files and generate sourcemap
rm -rf dist/
rojo sourcemap default.project.json -o sourcemap.json

# Initial processing with correct aliases
ROBLOX_DEV=true darklua process --config .darklua.json src/ dist/

# Convert alias requires in src/ and output in dist/, watching for changes
# Also, serve the files from dist/

rojo serve build.project.json \
    & rojo sourcemap default.project.json -o sourcemap.json --watch \
    & ROBLOX_DEV=true darklua process --config .darklua.json --watch src/ dist/