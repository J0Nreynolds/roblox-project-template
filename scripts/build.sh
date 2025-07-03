#!/bin/sh

set -e

# If Packages aren't installed, install them.
if [ ! -d "Packages" ]; then
    sh scripts/install-packages.sh
fi

# Clean and create dist directory
rm -rf dist/
mkdir -p dist

# Copy source files excluding test files using rsync
rsync -av --exclude="__tests__" --exclude="*.spec.lua" --exclude="jest.config.lua" src/ dist/

# Copy .luaurc if it exists
if [ -f "src/.luaurc" ]; then
    cp src/.luaurc dist/
fi

rojo sourcemap build.project.json -o sourcemap.json

ROBLOX_DEV=false darklua process --config .darklua.json dist/ dist/
rojo build build.project.json -o RobloxProjectTemplate.rbxl
