#!/bin/sh

set -e

# If Packages aren't installed, install them.
if [ ! -d "Packages" ] || [ ! -d "DevPackages" ]; then
    sh scripts/install-packages.sh
fi

# Clean test dist directory
rm -rf dist/

# Generate sourcemap for test src files (includes test files and runner)
rojo sourcemap default.test.project.json -o sourcemap.test.json

# Process files from src/ to dist/
ROBLOX_DEV=true darklua process --config .darklua.test.json src/ dist/
ROBLOX_DEV=true darklua process run-tests.luau test_runner/run-tests.luau

# Build test project
rojo build build.test.project.json --output RobloxProjectTemplate_Test.rbxl

# Try to run tests with run-in-roblox, but handle errors gracefully
echo "Attempting to run Jest tests..."
if run-in-roblox --place RobloxProjectTemplate_Test.rbxl --script test_runner/run-tests.luau 2>/dev/null; then
    echo "Tests completed successfully!"
    exit 0
else
    echo ""
    echo "❌ run-in-roblox failed or is not supported on this platform."
    echo ""
    echo "📋 To run tests in Roblox Studio:"
    echo "1. Open RobloxProjectTemplate_Test.rbxl in Roblox Studio"
    echo "2. Run tests via Command Bar: loadstring(game:GetService('ServerScriptService').TestRunner.Source)()"
    echo "3. Check the output window for test results"
    echo ""
    echo "ℹ️  For CI/automation, install run-in-roblox on Windows/macOS runners"
    exit 1
fi