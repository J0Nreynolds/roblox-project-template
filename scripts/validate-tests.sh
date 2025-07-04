#!/bin/bash

echo "🔍 Validating test setup..."

# Check if test dependencies exist
if [ ! -d "DevPackages" ]; then
    echo "❌ DevPackages directory not found. Run 'wally install' first."
    exit 1
fi

if [ ! -f "DevPackages/Jest.lua" ]; then
    echo "❌ Jest not found in DevPackages. Check wally.toml dev-dependencies."
    exit 1
fi

if [ ! -f "DevPackages/JestGlobals.lua" ]; then
    echo "❌ JestGlobals not found in DevPackages. Check wally.toml dev-dependencies."
    exit 1
fi

# Check if test files exist
if [ ! -d "src/__tests__" ]; then
    echo "❌ Test directory src/__tests__ not found."
    exit 1
fi

test_files=$(find src/__tests__ -name "*.spec.lua" | wc -l)
if [ "$test_files" -eq 0 ]; then
    echo "❌ No test files found. Test files should end with .spec.lua"
    exit 1
fi

# Check if jest config exists
if [ ! -f "src/jest.config.lua" ]; then
    echo "❌ Jest config not found at src/jest.config.lua"
    exit 1
fi

# Check if test runner exists
if [ ! -f "run-tests.lua" ]; then
    echo "❌ Test runner not found at run-tests.lua"
    exit 1
fi

# Check if test project config exists
if [ ! -f "test.project.json" ]; then
    echo "❌ Test project config not found at test.project.json"
    exit 1
fi

echo "✅ All test setup validation checks passed!"
echo "📊 Found $test_files test file(s) in src/__tests__/"
echo ""
echo "🏃 Ready to run tests:"
echo "  • Command line: ./scripts/test.sh"
echo "  • Roblox Studio: See TESTING.md for instructions"