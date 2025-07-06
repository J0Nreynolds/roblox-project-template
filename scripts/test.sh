#!/bin/sh

set -e

# Load project configuration
. scripts/config.sh

# Build test project using shared script
sh scripts/build-test.sh

TEST_PLACE_FILE=$(get_test_place_file)

# Try to run tests with run-in-roblox, but handle errors gracefully
echo "Attempting to run Jest tests..."
if run-in-roblox --place "$TEST_PLACE_FILE" --script test_runner/run-tests.luau 2>/dev/null; then
    echo "Tests completed successfully!"
    exit 0
else
    echo ""
    echo "❌ run-in-roblox failed or is not supported on this platform."
    echo ""
    echo "📋 To run tests in Roblox Studio:"
    echo "1. Open $TEST_PLACE_FILE in Roblox Studio"
    echo "2. Run tests via Command Bar: loadstring(game:GetService('ServerScriptService').TestRunner.Source)()"
    echo "3. Check the output window for test results"
    echo ""
    echo "ℹ️  For CI/automation, install run-in-roblox on Windows/macOS runners"
    exit 1
fi