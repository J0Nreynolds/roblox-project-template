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
- **Cross-Platform Scripts**: Lune-powered development scripts that work on Windows, macOS, and Linux

## Quick Start

### Prerequisites

- [Rokit](https://github.com/rojo-rbx/rokit) - Install via [instructions here](http://github.com/rojo-rbx/rokit?tab=readme-ov-file#installation) or [releases](https://github.com/rojo-rbx/rokit/releases)
- [Roblox Studio](https://create.roblox.com/) - For testing and publishing

### Setup

1. **Clone and setup**:
   ```bash
   git clone https://github.com/J0Nreynolds/roblox-project-template.git
   cd roblox-project-template
   rokit install         # Install development tools
   lune run install      # Install packages and setup project
   ```

2. **Configure project** (optional):
   ```bash
   # Copy configuration template and fill in your values
   cp project.config.template.toml project.config.toml
   # Edit project.config.toml to set PROJECT_NAME and other options
   ```

3. **Start developing**:
   ```bash
   lune run dev          # Start development server
   ```
   Then connect Roblox Studio to the Rojo server.

### Available Commands

```bash
lune run analyze    # Run type checking and analysis
lune run build      # Build production place file
lune run dev        # Start development server with file watching
lune run install    # Install tools and packages  
lune run test       # Build and run tests
lune run test-dev   # Start test development server
lune run test-wsl   # Run tests via PowerShell (WSL users - enables run-in-roblox)
lune run test-cloud # Run tests via Roblox Open Cloud (requires API setup)
```
> **See [CLOUD_TESTING.md](CLOUD_TESTING.md) for cloud testing setup instructions**

> **Note**: All development scripts are powered by [Lune](https://lune-org.github.io/docs), providing consistent cross-platform behavior without bash dependencies.
>
> **WSL Users**: For `run-in-roblox` support, use `lune run test-wsl` which runs tests via PowerShell.

## Project Configuration

The template uses a `project.config.toml` file for project settings. Copy the template to get started:

```bash
cp project.config.template.toml project.config.toml
```

Configuration options include:

```toml
[project]
name = "RobloxProjectTemplate"     # Used for generated place files

[test]
verbose = true                     # Test output verbosity (JEST_VERBOSE -> __VERBOSE__)
ci = false                        # CI mode for tests (JEST_CI -> __CI__)

[cloud]
test_place_id = ""                # Optional: Cloud testing place ID
test_universe_id = ""             # Optional: Cloud testing universe ID
# api_key = ""                    # Optional: API key for cloud testing
```

**Important**: 
- `project.config.toml` is gitignored - the template file is tracked
- Never commit API keys to version control
- For CI/CD, you can use GitHub repository variables/secrets instead of the config file

**Test Configuration**: The test settings are injected as globals during the darklua build process and control test runner behavior.

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
   - Use `lune run dev` for live development server
2. **Test**: 
   - Write tests in `src/__tests__/` 
   - Use `lune run test` to build and run tests
3. **Build**:
   - Use `lune run build` to create production place file

### File Watching & Aliases

The development uses `darklua` with file watching to transform code with proper path aliases (`@Common`, `@Client`, `@Server`) before syncing to Studio. The build pipeline ensures development matches production.

## Testing

### Quick Testing
```bash
lune run test        # Build and run all tests
lune run test-dev    # Live test development with file watching (preferred if you have issues with `run-in-roblox`)
lune run test-cloud  # Run tests via Roblox Open Cloud (see CLOUD_TESTING.md for setup)
```

### Manual Studio Testing
1. Use live test development server: `lune run test-dev`
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

- **run-in-roblox**: Windows/macOS only (WSL users should use `lune run test-wsl`)
- **File watching**: WSL users must use PowerShell or CMD, or host project on Linux filesystem

## Troubleshooting

### Test Execution Failures on Windows/WSL

If `lune run test` or `lune run test-wsl` fails with execution errors, restart Windows Host Network Service in admin PowerShell:

```powershell
net stop hns
net start hns
```

## Contributing

1. Fork the repository
2. Create a feature branch  
3. Add your changes
4. Ensure all CI checks pass
5. Submit a pull request