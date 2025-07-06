#!/bin/sh

set -e

# Load project configuration
. scripts/config.sh

# If Packages aren't installed, install them.
if [ ! -d "Packages" ] || [ ! -d "DevPackages" ]; then
    sh scripts/install-packages.sh
fi

# Initial setup: clean and generate sourcemap
rm -rf dist/
rojo sourcemap default.test.project.json -o sourcemap.test.json

# Initial processing
TEST_IN_STUDIO=true darklua process \
--config .darklua.test.json src/ dist/
TEST_IN_STUDIO=true darklua process \
--config .darklua.test.json run-tests.luau test_runner/run-tests.luau

# Build test project
TEST_PLACE_FILE=$(get_test_place_file)
rojo build build.test.project.json --output "$TEST_PLACE_FILE"
echo "✅ Successfully built test project: $TEST_PLACE_FILE"

echo "Starting test development server..."
echo "- Run tests via Command Bar: loadstring(game:GetService('ServerScriptService').TestRunner.Source)()"
echo "- File watching enabled for test development"
echo "- Server available at http://localhost:34872"

# Start test server with file watching
rojo serve build.test.project.json \
    & rojo sourcemap default.test.project.json -o sourcemap.test.json --watch \
    & TEST_IN_STUDIO=true darklua process --watch \
    --config .darklua.test.json src/ dist/ \
    & TEST_IN_STUDIO=true darklua process --watch \
    --config .darklua.test.json run-tests.luau test_runner/run-tests.luau