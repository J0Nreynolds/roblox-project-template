#!/bin/sh

# Helper script to run tests via PowerShell for WSL/Linux environments
# This enables access to run-in-roblox which only works on Windows/macOS

set -e

echo "🔄 Running tests via PowerShell (for run-in-roblox support)..."
echo ""

# Get the Windows path for the current directory
WINDOWS_PATH=$(pwd | sed 's|/mnt/c|C:|' | sed 's|/|\\|g')

# Run test commands through PowerShell
powershell.exe -Command "& { 
    Set-Location '$WINDOWS_PATH'
    & ./scripts/aliases.sh
    git test
}"

echo ""
echo "✅ PowerShell test execution completed"