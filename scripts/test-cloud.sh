#!/bin/sh

# Cloud-based testing using Roblox Open Cloud API
# This enables CI testing on any platform without run-in-roblox

set -e

# Load project configuration
. scripts/config.sh

echo "🌩️  Running tests via Roblox Open Cloud..."

# Check required environment variables
if [ -z "$ROBLOX_API_KEY" ]; then
    echo "❌ ROBLOX_API_KEY environment variable required"
    exit 1
fi

if [ -z "$ROBLOX_TEST_UNIVERSE_ID" ]; then
    echo "❌ ROBLOX_TEST_UNIVERSE_ID environment variable required"
    exit 1
fi

if [ -z "$ROBLOX_TEST_PLACE_ID" ]; then
    echo "❌ ROBLOX_TEST_PLACE_ID environment variable required"
    exit 1
fi

# Build test project using shared script
sh scripts/build-test.sh

TEST_PLACE_FILE=$(get_test_place_file)

echo "☁️  Uploading and executing tests via Open Cloud..."

# Set environment variables for Python script
export ROBLOX_UNIVERSE_ID="$ROBLOX_TEST_UNIVERSE_ID"
export ROBLOX_PLACE_ID="$ROBLOX_TEST_PLACE_ID"

# Execute cloud tests
if command -v python >/dev/null 2>&1; then
    python ./scripts/python/upload_and_run_task.py "$TEST_PLACE_FILE" test_runner/run-tests.luau
elif command -v python3 >/dev/null 2>&1; then
    python3 ./scripts/python/upload_and_run_task.py "$TEST_PLACE_FILE" test_runner/run-tests.luau
else
    echo "❌ Python not found. Please install Python 3"
    exit 1
fi

echo "✅ Cloud test execution completed"