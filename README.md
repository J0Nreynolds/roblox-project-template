<!-- Allow this file to not have a first line heading -->
<!-- markdownlint-disable-file MD041 no-emphasis-as-heading -->

<!-- inline html -->
<!-- markdownlint-disable-file MD033 -->

<div align="center">

# `📦 Roblox Project Template`

**A comprehensive starting point for Roblox projects. Implements Rojo, Darklua, Wally, and more.**

[![Build status](https://github.com/J0Nreynolds/roblox-project-template/workflows/CI/badge.svg)](https://github.com/J0Nreynolds/roblox-project-template/actions)

</div>

## Features

- **Modern Development Stack**: Rojo, Darklua, Wally, and Rokit for comprehensive tooling
- **React Integration**: Built-in React and ReactRoblox for modern UI development
- **Testing Framework**: Jest-Lua + `run-in-roblox` for testing
- **Code Quality**: Stylua formatting, Selene linting, and type checking
- **Git Workflow**: Pre-configured aliases and scripts for streamlined development

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

2. **Start developing**:
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
git test-wsl   # Run tests via PowerShell (specifically for WSL users to use `run-in-roblox`)
```

> **Windows Users**: Use Git aliases for best experience. Manual script execution opens separate windows if using Git Bash, making it difficult to read the script output.
>
> **WSL Users**: File watching (`git dev` or `git test-dev`) requires either PowerShell/CMD or hosting the project on Linux filesystem (not `/mnt/c/`).

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