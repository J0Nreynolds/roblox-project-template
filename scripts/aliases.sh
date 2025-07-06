#!/bin/sh

set -e

git config --local alias.sh !bash
git config --local alias.analyze "!sh ./scripts/analyze.sh"
git config --local alias.build "!sh ./scripts/build.sh"
git config --local alias.dev "!sh ./scripts/dev.sh"
git config --local alias.install "!sh ./scripts/install-packages.sh"
git config --local alias.test "!sh ./scripts/test.sh"
git config --local alias.test-dev "!sh ./scripts/test-dev.sh"
git config --local alias.test-wsl "!sh ./scripts/test-wsl.sh"