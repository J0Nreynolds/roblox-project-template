#!/bin/sh

set -e

# If Packages aren't installed, install them.
if [ ! -d "Packages" ]; then
    sh scripts/install-packages.sh
fi

echo "Starting development server with live sync..."
echo "- Rojo server will be available for Roblox Studio"
echo "- DEV mode enabled with live file watching" 
echo "- Files will auto-sync when changed"
echo "- Aliases transformed in real-time"

# First copy files and process in place for proper transformation
echo "Processing files for initial sync..."
rsync -av --delete src/ dist/
rojo sourcemap default.project.json -o sourcemap.json
ROBLOX_DEV=true darklua process --config .darklua-dev.json dist/ dist/

echo "Starting live sync processes..."

# Function to sync and transform files
sync_and_transform() {
    echo "Syncing and transforming files..."
    rsync -av --delete src/ dist/ >/dev/null 2>&1
    ROBLOX_DEV=true darklua process --config .darklua-dev.json dist/ dist/ >/dev/null 2>&1
    echo "Files synced and transformed."
}

# Start all processes concurrently
rojo serve default.project.json \
    & rojo sourcemap default.project.json -o sourcemap.json --watch \
    & (while true; do
        # Use inotifywait with timeout and specific events
        if inotifywait -t 1 -r -e modify,move,create,delete src/ >/dev/null 2>&1; then
            sync_and_transform
        fi
    done)