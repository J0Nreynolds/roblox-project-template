#!/bin/sh

set -e

# Load project configuration
. scripts/config.sh

echo "📦 Building project..."

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
PRODUCTION_PLACE_FILE=$(get_production_place_file)
rojo build build.project.json -o "$PRODUCTION_PLACE_FILE"
echo "✅ Successfully built production place: $PRODUCTION_PLACE_FILE"
