#!/bin/sh

set -e

# If Packages aren't installed, install them.
if [ ! -d "Packages" ]; then
    sh scripts/install-packages.sh
fi

rojo sourcemap default.project.json -o sourcemap.json
curl -O https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/main/scripts/globalTypes.d.luau

echo "Running type analysis..."

# Capture luau-lsp output and exit code
ANALYSIS_OUTPUT=$(luau-lsp analyze --definitions=globalTypes.d.luau --base-luaurc=src/.luaurc \
    --sourcemap=sourcemap.json --settings=.vscode/settings.json \
    --no-strict-dm-types --ignore Packages/**/*.lua --ignore Packages/**/*.luau \
    --ignore DevPackages/**/*.lua --ignore DevPackages/**/*.luau \
    --ignore lib/**/*.lua --ignore lib/**/*.luau \
    src/ 2>&1)
ANALYSIS_EXIT_CODE=$?

# Show output if there are issues
if [ -n "$ANALYSIS_OUTPUT" ]; then
    echo "$ANALYSIS_OUTPUT"
fi

# Handle exit codes and show appropriate message
if [ $ANALYSIS_EXIT_CODE -eq 0 ]; then
    if [ -z "$ANALYSIS_OUTPUT" ]; then
        echo "✅ Type analysis passed - no issues found!"
    fi
    exit 0
else
    echo "❌ Type analysis failed"
    exit $ANALYSIS_EXIT_CODE
fi
