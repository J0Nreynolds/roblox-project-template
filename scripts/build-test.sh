#!/bin/sh

set -e

# Load project configuration
. scripts/config.sh

echo "📦 Building test project..."

# If Packages aren't installed, install them.
if [ ! -d "Packages" ] || [ ! -d "DevPackages" ]; then
    sh scripts/install-packages.sh
fi

# Clean test dist directory
rm -rf dist/

# Generate sourcemap for test src files (includes test files and runner)
rojo sourcemap default.test.project.json -o sourcemap.test.json

# Process files from src/ to dist/
TEST_IN_STUDIO=false darklua process \
    --config .darklua.test.json src/ dist/
# Process test runner
TEST_IN_STUDIO=false darklua process \
    --config .darklua.test.json run-tests.luau test_runner/run-tests.luau

# Build test project
TEST_PLACE_FILE=$(get_test_place_file)
rojo build build.test.project.json --output "$TEST_PLACE_FILE"
echo "✅ Successfully built test project: $TEST_PLACE_FILE"