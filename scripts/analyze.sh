#!/bin/sh

set -e

# If Packages aren't installed, install them.
if [ ! -d "Packages" ]; then
    sh scripts/install-packages.sh
fi

rojo sourcemap default.project.json -o sourcemap.json
curl -O https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/main/scripts/globalTypes.d.luau

echo "Running type analysis..."

# Run luau-lsp analysis and capture output
if luau-lsp analyze --definitions=globalTypes.d.luau --base-luaurc=src/.luaurc \
    --sourcemap=sourcemap.json --settings=.vscode/settings.json \
    --no-strict-dm-types --ignore Packages/**/*.lua --ignore Packages/**/*.luau \
    --ignore DevPackages/**/*.lua --ignore DevPackages/**/*.luau \
    --ignore lib/**/*.lua --ignore lib/**/*.luau \
    src/; then
    echo "✅ Type analysis passed - no issues found!"
else
    echo "❌ Type analysis failed - see errors above"
    exit 1
fi
