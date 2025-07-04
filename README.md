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
[![Build status](https://github.com/grilme99/roblox-project-template/workflows/CI/badge.svg)](https://github.com/grilme99/roblox-project-template/actions)

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

### Testing

**Command Line (Windows/macOS)**:
```bash
./scripts/test.sh
```

**Roblox Studio (recommended for WSL)**:
1. Build test project: `./scripts/test.sh` (processes files through Darklua)
2. Open `RobloxProjectTemplate_Test.rbxl` in Roblox Studio
3. Run in Command Bar: `loadstring(game:GetService("ServerScriptService").TestRunner.Source)()`

**Note**: Test files are processed through Darklua for consistency with production builds.

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

- `./scripts/dev.sh` - Start development server with live sync
- `./scripts/build.sh` - Build the project for production
- `./scripts/test.sh` - Run Jest tests
- `./scripts/validate-tests.sh` - Validate test setup
- `./scripts/install-packages.sh` - Install tools and packages
- `./scripts/analyze.sh` - Run code analysis

**Note**: If scripts don't execute in WSL/Linux, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md#script-execution-issues-in-wsllinux) for line ending fixes.

## Testing

This template includes Jest-Lua for testing. Tests are located in `src/__tests__/` and follow the pattern `*.spec.lua`.

### Writing Tests

```lua
local JestGlobals = require("@DevPackages/JestGlobals")

local describe = JestGlobals.describe
local it = JestGlobals.it
local expect = JestGlobals.expect

local myModule = require("@Project/Common/MyModule")

describe("MyModule", function()
    it("should work correctly", function()
        expect(myModule.someFunction()).toBe(expectedValue)
    end)
end)
```

### Running Tests

- **Command Line**: `./scripts/test.sh`
- **Roblox Studio**: Open the place file and run `run-tests.lua`

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

```bash
# Install tools (after installing Rokit)
rokit install

# Or use the convenience script
./scripts/install-packages.sh
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

### Darklua Configuration

The template uses separate Darklua configurations for different environments:

- **`.darklua.json`**: Production builds (excludes tests, transforms aliases to Roblox paths)
- **`.darklua-test.json`**: Test builds (includes tests, uses `test-dist/` structure)
- **`.darklua-dev.json`**: Development builds (for live sync, transforms aliases properly)

All configurations support the same aliases (`@Common`, `@Client`, `@Services`, etc.) and transform them to appropriate require paths for their target environment.

### Wally Dependencies

Dependencies are managed in `wally.toml`:

- **React**: Modern UI library
- **ReactRoblox**: React renderer for Roblox
- **Jest**: Testing framework (dev dependency)
- **JestGlobals**: Jest globals (dev dependency)

## Development Workflow

1. **Start Development**: `./scripts/dev.sh` - Starts Rojo server with live sync
2. **Connect Studio**: Open Roblox Studio and connect to `http://localhost:34872`
3. **Write Code**: Edit files in `src/` - changes automatically sync to Roblox Studio
4. **Write Tests**: Create `*.spec.lua` files in `src/__tests__/`
5. **Run Tests**: `./scripts/test.sh` or test in Roblox Studio
6. **Build**: `./scripts/build.sh` - Creates production-ready place file

### Live Development Features

The development server provides:
- **Live file synchronization**: Changes to `src/` files automatically sync to Roblox Studio
- **Alias transformation**: `@Common`, `@Client`, etc. are transformed to proper Roblox paths
- **Hot reloading**: Code changes are reflected immediately in Studio
- **Consistent build process**: Development uses the same transformation pipeline as production

### File Watching

The development script uses `inotifywait` with smart timeout handling for efficient file watching on all platforms, including WSL with Windows-mounted drives.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request
