<!-- Allow this file to not have a first line heading -->
<!-- markdownlint-disable-file MD041 no-emphasis-as-heading -->

<!-- inline html -->
<!-- markdownlint-disable-file MD033 -->

<div align="center">

# `📦 Roblox Project Template`

**A comprehensive Roblox project template with modern tooling, flexible testing, and CI/CD support. Features Rojo, Darklua, Jest-Lua, and Roblox Open Cloud integration.**

[![Build status](https://github.com/J0Nreynolds/roblox-project-template/workflows/CI/badge.svg)](https://github.com/J0Nreynolds/roblox-project-template/actions)

</div>

## Features

- **Modern Development Stack**: Rojo, Darklua, Wally, and Rokit for comprehensive tooling
- **React Integration**: Built-in React and ReactRoblox for modern UI development
- **Flexible Testing**: Jest-Lua with multiple execution modes (local, cloud, and live development)
- **Cloud Testing**: Roblox Open Cloud API integration for CI/CD-friendly testing without local dependencies
- **Code Quality**: Stylua formatting, Selene linting, and type checking
- **Git Workflow**: Pre-configured aliases and scripts for streamlined development
- **Cross-Platform**: Windows, macOS, and Linux support with WSL considerations

## Quick Start

### Prerequisites

- [Rokit](https://github.com/rojo-rbx/rokit) - Install via [instructions here](http://github.com/rojo-rbx/rokit?tab=readme-ov-file#installation) or [releases](https://github.com/rojo-rbx/rokit/releases)
- [Roblox Studio](https://create.roblox.com/) - For testing and publishing
- **[Windows Users]** [Git Bash](https://git-scm.com/downloads) - For running scripts (comes with Git for Windows)

### Setup

1. **Clone and setup**:
   ```bash
   git clone https://github.com/J0Nreynolds/roblox-project-template.git
   cd roblox-project-template
   ./scripts/aliases.sh  # Creates convenient git aliases
   git install           # Installs tools and packages
   ```

2. **Configure project** (optional):
   ```bash
   # Copy environment template and fill in your values
   cp project.env.template project.env
   nano project.env   # Set PROJECT_NAME and other options
   ```

3. **Start developing**:
   ```bash
   git dev               # Start development server
   ```
   Then connect Roblox Studio to the Rojo server.

### Available Commands

```bash
git analyze    # Run type checking and analysis
git build      # Build production place file
git dev        # Start development server with file watching
git install    # Install tools and packages  
git test       # Build and run tests
git test-dev   # Start test development server
git test-wsl   # Run tests via PowerShell (WSL users - enables run-in-roblox)
git test-cloud # Run tests via Roblox Open Cloud (requires API setup)
```
> **See [CLOUD_TESTING.md](CLOUD_TESTING.md) for cloud testing setup instructions**

> **Windows Users**: Use Git aliases for best experience. Manual script execution opens separate windows if using Git Bash, making it difficult to read the script output.
>
> **WSL Users**: File watching (`git dev` or `git test-dev`) requires either PowerShell/CMD or hosting the project on Linux filesystem (not `/mnt/c/`).

## Project Configuration

The template uses a `project.env` file for project settings. Copy the template to get started:

```bash
cp project.env.template project.env
```

Configuration options include:

```bash
# Project Environment Configuration
PROJECT_NAME=""                    # Used for generated place files
JEST_VERBOSE=false                 # Test output verbosity
JEST_CI=true                       # CI mode for tests
ROBLOX_TEST_PLACE_ID=""           # Optional: Cloud testing place ID
ROBLOX_TEST_UNIVERSE_ID=""        # Optional: Cloud testing universe ID
ROBLOX_API_KEY=""                 # Optional: API key for cloud testing
```

**Important**: 
- All `*.env` files are gitignored - the template file is tracked
- Never commit API keys to version control
- For CI/CD, you can use GitHub repository variables/secrets instead of the env file

**Test Configuration**: The `JEST_VERBOSE` and `JEST_CI` variables are injected as globals during the darklua build process and control test runner behavior.

This affects:
- **Production builds**: `YourProjectName.rbxl`
- **Test builds**: `YourProjectName_Test.rbxl`
- **Cloud testing**: Uses the specified place/universe IDs and API key (see [CLOUD_TESTING.md](CLOUD_TESTING.md) for setup)
- **Test behavior**: Controls verbosity and CI mode through injected globals

**Tip**: You may also want to update the Rojo project names in `build.project.json` and `build.test.project.json` to match your project name.

## Project Structure

```
src/
├── Client/          # Client-side code (Controllers, UI, etc.)
├── Server/          # Server-side code (Services, etc.)  
├── Common/          # Shared code between Client and Server
└── __tests__/       # Test files (*.spec.luau)
```

## Development Workflow

1. **Code**: 
   - Edit files in `src/`
   - Use `git dev` for live development server
2. **Test**: 
   - Write tests in `src/__tests__/` 
   - Use `git test` to build and run tests
3. **Build**:
   - Use `git build` to create production place file

### File Watching & Aliases

The development uses `darklua` with file watching to transform code with proper path aliases (`@Common`, `@Client`, `@Server`) before syncing to Studio. The build pipeline ensures development matches production.

## Testing

### Quick Testing
```bash
git test        # Build and run all tests
git test-dev    # Live test development with file watching (preferred if you have issues with `run-in-roblox`)
git test-cloud  # Run tests via Roblox Open Cloud (see CLOUD_TESTING.md for setup)
```

### Manual Studio Testing
1. Use live test development server: `git test-dev`
2. Open `RobloxProjectTemplate_Test.rbxl` in Studio
3. Run: `loadstring(game:GetService("ServerScriptService").TestRunner.Source)()`

### Writing Tests

Place tests in `src/__tests__/` with `*.spec.luau` naming:

```lua
local JestGlobals = require("@DevPackages/JestGlobals")
local describe, it, expect = JestGlobals.describe, JestGlobals.it, JestGlobals.expect

local myModule = require("@Project/Common/MyModule")

describe("MyModule", function()
    it("should do something", function()
        expect(myModule.doSomething()).toBe(true)
    end)
end)
```

**Note**: Tests use `@Project` alias to access all code since the test environment places everything under `ReplicatedStorage.Project`.

### Test Configuration

The test runner uses global injection to configure behavior at build time. Environment variables from `project.env` are injected as globals during the darklua processing:

- `JEST_VERBOSE` → `__VERBOSE__` global: Controls test output verbosity
- `JEST_CI` → `__CI__` global: Enables CI mode for cleaner output
- `TEST_IN_STUDIO` → `__STUDIO__` global: Detects Studio environment for color handling

This happens in `.darklua.test.json` using the `inject_global_value` rule, allowing compile-time configuration without runtime overhead.

For Jest matchers and patterns, see [Jest-Lua documentation](https://jsdotlua.github.io/jest-lua/).


## Notes

- **run-in-roblox**: Windows/macOS only (WSL users should use `git test-wsl`)
- **File watching**: WSL users must use PowerShell or CMD, or host project on Linux filesystem
- **Git aliases**: Recommended for Windows to avoid terminal window issues

## Contributing

1. Fork the repository
2. Create a feature branch  
3. Add your changes
4. Ensure all CI checks pass
5. Submit a pull request