#!/bin/sh

set -e

# Install tools with Rokit (if available)
if command -v rokit >/dev/null 2>&1; then
    echo "Installing tools with Rokit..."
    rokit install
else
    echo "Rokit not found. Please install Rokit: https://github.com/rojo-rbx/rokit"
    echo "Or ensure tools are available in PATH manually."
fi

# Install packages with Wally
wally install

# Patch the Wally package link modules to also export Luau type definitions.
rojo sourcemap default.project.json -o sourcemap.json
wally-package-types --sourcemap sourcemap.json Packages/
