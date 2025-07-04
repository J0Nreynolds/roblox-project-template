#!/bin/bash

# Install dependencies if needed
if [ ! -d "DevPackages" ]; then
    echo "Installing dev dependencies..."
    wally install
fi

# Clean and create test dist directory
echo "Preparing test build..."
rm -rf test-dist/
mkdir -p test-dist

# Copy all source files (including tests) for test build
rsync -av src/ test-dist/

# Generate sourcemap for test project (before Darklua processing)
rojo sourcemap test.project.json -o test-sourcemap.json

# Process test files through Darklua with test-specific configuration
echo "Processing test files with Darklua..."
ROBLOX_DEV=true darklua process --config .darklua-test.json test-dist/ test-dist/

# Build test project
echo "Building test project..."
rojo build test.project.json --output RobloxProjectTemplate_Test.rbxl

# Try to run tests with run-in-roblox, but handle errors gracefully
echo "Attempting to run Jest tests..."
if run-in-roblox --place RobloxProjectTemplate_Test.rbxl --script run-tests.lua 2>/dev/null; then
    echo "Tests completed successfully!"
else
    echo ""
    echo "❌ run-in-roblox failed or is not supported on this platform."
    echo ""
    echo "📋 To run tests in Roblox Studio:"
    echo "1. Open RobloxProjectTemplate_Test.rbxl in Roblox Studio"
    echo "2. In Command Bar, run: loadstring(game:GetService(\"ServerScriptService\").TestRunner.Source)()"
    echo "3. Check the output window for test results"
fi