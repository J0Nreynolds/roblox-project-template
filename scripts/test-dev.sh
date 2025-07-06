#!/bin/sh

set -e

# If Packages aren't installed, install them.
if [ ! -d "Packages" ] || [ ! -d "DevPackages" ]; then
    sh scripts/install-packages.sh
fi

# Initial setup: clean and generate sourcemap
rm -rf dist/
rojo sourcemap default.test.project.json -o sourcemap.test.json

# Initial processing
ROBLOX_DEV=true darklua process --config .darklua.test.json src/ dist/
ROBLOX_DEV=true darklua process run-tests.luau test_runner/run-tests.luau

echo "Starting test development server..."
echo "- Run tests via Command Bar: loadstring(game:GetService('ServerScriptService').TestRunner.Source)()"
echo "- File watching enabled for test development"
echo "- Server available at http://localhost:34872"

# Start test server with file watching
rojo serve build.test.project.json \
    & rojo sourcemap default.test.project.json -o sourcemap.test.json --watch \
    & ROBLOX_DEV=true darklua process --watch --config .darklua.test.json src/ dist/ \
    & ROBLOX_DEV=true darklua process --watch run-tests.luau test_runner/run-tests.luau