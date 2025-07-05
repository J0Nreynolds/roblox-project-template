<!-- Allow this file to not have a first line heading -->
<!-- markdownlint-disable-file MD041 no-emphasis-as-heading -->

<!-- inline html -->
<!-- markdownlint-disable-file MD033 -->

<div align="center">

<!--- FIXME: Pick an emoji and name your project! --->
# `📦 Roblox Project Template`

<!--- FIXME: Write short catchy description/tagline of project --->
**A comprehensive starting point for Roblox projects. Implements Rojo, Darklua, Wally, and more.**

<!--- FIXME: Update crate, repo and CI workflow names here! Remove any that are not relevant --->
[![Build status](https://github.com/J0Nreynolds/roblox-project-template/workflows/CI/badge.svg)](https://github.com/J0Nreynolds/roblox-project-template/actions)

</div>

## Features

- **Modern Development Stack**: Uses Rojo for syncing, Darklua for optimization, and Wally for package management
- **Tool Management**: Rokit for managing development tools and versions
- **React Integration**: Built-in support for React and ReactRoblox for modern UI development
- **Testing Framework**: Jest-Lua integration for comprehensive testing
- **Code Quality**: Stylua for formatting and Selene for linting
- **Build Scripts**: Automated build, development, and testing workflows

## Quick Start

### Prerequisites

- [Rokit](https://github.com/rojo-rbx/rokit) - Tool manager for Roblox projects
- [run-in-roblox](https://github.com/rojo-rbx/run-in-roblox) - For running tests from CLI (optional)

### Installation

1. **Install Rokit**: 
   ```bash
   # Install via Cargo
   cargo install --git https://github.com/rojo-rbx/rokit
   
   # Or download from releases
   # https://github.com/rojo-rbx/rokit/releases
   ```

2. **Clone this repository**

3. **Install tools and dependencies**:
   ```bash
   ./scripts/install-packages.sh
   ```
   This will install both development tools (via Rokit) and packages (via Wally).

4. **Start development server**:
   ```bash
   ./scripts/dev.sh
   ```
   
## Project Structure

```
src/
├── Client/          # Client-side code
│   ├── Controllers/ # Client controllers
│   ├── UI/          # React components and UI logic
│   └── Runtime.client.lua
├── Server/          # Server-side code
│   ├── Services/    # Server services
│   └── Runtime.server.lua
├── Common/          # Shared code
│   ├── Log.lua      # Logging utility
│   └── Sum.lua      # Example utility function
├── __tests__/       # Test files
│   ├── Sum.spec.lua
│   └── Log.spec.lua
└── jest.config.lua  # Jest configuration
```

## Scripts

- `./scripts/dev.sh` - Start development server with file watching
- `./scripts/test-dev.sh` - Start test development server with file watching
- `./scripts/build.sh` - Build the project for production
- `./scripts/test.sh` - Build test project and run Jest tests
- `./scripts/install-packages.sh` - Install tools and packages
- `./scripts/analyze.sh` - Run code analysis


## Tool Management

This project uses [Rokit](https://github.com/rojo-rbx/rokit) for managing development tools. All tools and their versions are defined in `rokit.toml`:

- **darklua** - Lua transformation tool
- **wally** - Package manager
- **wally-package-types** - Type definitions for Wally packages
- **rojo** - File sync tool
- **stylua** - Code formatter
- **selene** - Linter
- **luau-lsp** - Language server

### Tool Installation
#### Use the convenience script to install tools and packages
```bash
./scripts/install-packages.sh
```
#### Or install manually
```bash
# Install tools (after installing Rokit)
rokit install

# Install packages (after installing Wally)
wally install
```

**Note**: After installing Rokit for the first time, restart your shell/terminal to ensure the tools are in your PATH.

## Configuration

### Jest Configuration

Tests are configured in `src/jest.config.lua`:

```lua
return {
    testMatch = { "**/*.spec" }
}
```

### Development Environment

The development server (`scripts/dev.sh`) uses a two-project-file system to correctly resolve path aliases while serving the game to Roblox Studio.

- **`build.project.json`**: Used by `rojo serve`. This project file points to the `dist/` directory, which contains the processed code that is ready to be served to Studio.
- **`default.project.json`**: Used by `rojo sourcemap`. This project file points to the `src/` directory, allowing Darklua to correctly map path aliases like `@Client` and `@Server` during development.

This setup ensures that the development environment in Studio is as close as possible to the final production build.

## Development Workflow

1. **Start Development**: `./scripts/dev.sh` - Starts Rojo server with file watching on `dist/`
2. **Connect Studio**: Open Roblox Studio and connect to `http://localhost:34872`
3. **Write Code**: Edit files in `src/` - changes will sync to Roblox Studio when files are processed by `darklua --watch`
4. **Write Tests**: Create `*.spec.lua` files in `src/__tests__/`
5. **Test Development**: `./scripts/test-dev.sh` for live test development, or `./scripts/test.sh` to build and run tests
6. **Build**: `./scripts/build.sh` - Creates production-ready place file

### Development Features

The development server provides:
- **File watching**: Changes to `src/` files are monitored and processed via `darklua`
- **Alias transformation**: `@Common`, `@Client`, etc. are transformed to proper Roblox paths
- **Live sync**: Code changes are processed and available for Studio sync
- **Consistent build process**: Development uses the same transformation pipeline as production

**Windows Users**: File watching works best in native Windows environments. WSL users have two options:
- **Option 1**: Run development scripts from PowerShell or Windows Command Prompt
- **Option 2**: Host the project on the Linux filesystem (e.g., `/home/username/projects/`) instead of Windows-mounted drives (`/mnt/c/`) to enable file watching in WSL

## Testing

The template provides two approaches for running tests:

### Test Development Server

For active test development with live sync:

```bash
./scripts/test-dev.sh
```

- Starts a Rojo server for test development
- Enables file watching for both source files and test files
- Tests run when executed via Command Bar: `loadstring(game:GetService("ServerScriptService").TestRunner.Source)()`
- Changes to tests sync immediately to Studio
- Connect Studio to `http://localhost:34872`

### Test Build & Run

For one-time test execution:

```bash
./scripts/test.sh
```

- Builds a complete test project place file
- Attempts to run tests via `run-in-roblox` (if available)
- Creates `RobloxProjectTemplate_Test.rbxl` for manual testing
- Tests run when executed manually in Studio Command Bar

### Test Architecture Notes

**Project Alias Requirement**: Tests must use the `@Project` alias to access both Client and Server code, as the test environment places all code under `ReplicatedStorage.Project` for accessibility from test scripts. This differs from the normal runtime where Client and Server code are separated.

Example test requiring code from both Client and Server:
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Project = ReplicatedStorage.Project

-- Access Client code
local UIController = require(Project.Client.Controllers.UIController)
-- Access Server code  
local TestService = require(Project.Server.Services.TestService)
-- Access Common code
local Log = require(Project.Common.Log)
```

This unified structure allows tests to validate interactions between Client, Server, and Common code in a single test environment.

## Writing Tests

### Test File Structure

Tests should be placed in `src/__tests__/` and follow the naming pattern `*.spec.luau`:

```
src/
├── __tests__/
│   ├── Sum.spec.luau
│   ├── Log.spec.luau
│   └── MyModule.spec.luau
└── Common/
    ├── Sum.luau
    └── Log.luau
```

### Basic Test Structure

```lua
local JestGlobals = require("@DevPackages/JestGlobals")

local describe = JestGlobals.describe
local it = JestGlobals.it
local expect = JestGlobals.expect

local myModule = require("@Project/Common/MyModule")

describe("MyModule", function()
    it("should do something", function()
        expect(myModule.doSomething()).toBe(true)
    end)
end)
```

For available Jest matchers and advanced testing patterns, see the [Jest-Lua documentation](https://jsdotlua.github.io/jest-lua/).

### Studio Setup

To run tests in Roblox Studio, enable the LoadModule flag:

1. Create `ClientAppSettings.json` in your Roblox settings folder:
   ```json
   {
       "FFlagEnableLoadModule": true
   }
   ```

2. Restart Roblox Studio

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request
