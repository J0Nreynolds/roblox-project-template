# Troubleshooting Guide

## Common Issues and Solutions

### Rokit Tool Management Issues

#### Rokit Not Found

**Problem**: `rokit: command not found` when running scripts.

**Solutions**:
1. **Install Rokit**:
   ```bash
   # Via Cargo (recommended)
   cargo install --git https://github.com/rojo-rbx/rokit
   
   # Or download from releases
   # https://github.com/rojo-rbx/rokit/releases
   ```

2. **Restart your shell/terminal** after installation to ensure Rokit is in your PATH.

3. **Alternative installation methods**:
   - Download binary from [Rokit releases](https://github.com/rojo-rbx/rokit/releases)
   - Add the binary to your PATH manually

#### Tools Not Found After Rokit Installation

**Problem**: Commands like `rojo`, `wally`, `darklua` not found even after `rokit install`.

**Solutions**:
1. **Run `rokit install`** to install tools defined in `rokit.toml`
2. **Restart your shell** to ensure tools are in PATH
3. **Check if tools are installed**:
   ```bash
   rokit list
   ```

4. **Manual tool verification**:
   ```bash
   which rojo
   which wally
   which darklua
   ```

#### Rokit Tool Version Issues

**Problem**: Using wrong version of tools or outdated tools.

**Solutions**:
1. **Update tools**:
   ```bash
   rokit install  # Reinstalls tools to versions in rokit.toml
   ```

2. **Check current versions**:
   ```bash
   rokit list
   ```

3. **Update `rokit.toml`** if you need newer tool versions

### Script Execution Issues in WSL/Linux

**Problem**: Scripts in the `scripts/` folder show "cannot execute: required file not found" or similar errors.

**Cause**: This is typically caused by Windows line endings (CRLF) instead of Unix line endings (LF) in shell scripts. Windows Git may convert line endings when cloning or creating files.

**Solutions**:

#### Method 1: Manual Fix (Quick)
1. Copy the script contents
2. Create a new file (e.g., `script-name2.sh`)
3. Paste the contents into the new file
4. Delete the original script
5. Rename the new file to the original name

#### Method 2: Using dos2unix (Recommended)
```bash
# Install dos2unix if not available
sudo apt-get install dos2unix

# Convert all scripts at once
find scripts/ -name "*.sh" -exec dos2unix {} \;

# Or convert individual files
dos2unix scripts/test.sh
dos2unix scripts/validate-tests.sh
```

#### Method 3: Using sed
```bash
# Convert individual files
sed -i 's/\r$//' scripts/test.sh
sed -i 's/\r$//' scripts/validate-tests.sh

# Or convert all .sh files
find scripts/ -name "*.sh" -exec sed -i 's/\r$//' {} \;
```

#### Method 4: Git Configuration (Preventive)
Configure Git to handle line endings properly:

```bash
# Set Git to auto-convert line endings
git config core.autocrlf true    # On Windows
git config core.autocrlf input   # On WSL/Linux/macOS

# Or set it globally
git config --global core.autocrlf input
```

### Testing Issues

#### Jest-Lua Module Not Found

**Problem**: `unknown source name '@DevPackages'` or `unknown source name '@Project'`

**Solutions**:
1. Make sure you're using the correct project file:
   ```bash
   rojo build test.project.json --output RobloxProjectTemplate_Test.rbxl
   ```

2. Verify dependencies are installed:
   ```bash
   wally install
   ```

3. Check that `DevPackages` and `Packages` directories exist and contain the required modules.

#### Unsupported Alias Errors in Test Environment

**Problem**: "Path contains unsupported alias" when running tests in Roblox Studio

**Cause**: This should not occur with the current template setup.

**Solution**: The template now processes test files through Darklua, ensuring alias consistency between test and production environments.

**How it works**:
- Production build: `src/` → Darklua → `dist/` → build
- Test build: `src/` → Darklua → `test-dist/` → build
- Both use identical alias resolution

**If you still see this error**:
1. Make sure you're using `./scripts/test.sh` to build tests
2. Check that all aliases in `.darklua.json` are properly configured
3. Verify that `test-dist/` directory exists and contains processed files

#### run-in-roblox Not Working

**Problem**: `run-in-roblox` fails with "Could not locate a Roblox Studio installation"

**Solutions**:
1. **WSL Users**: This is expected. Use Roblox Studio instead:
   - Build test project: `rojo build test.project.json --output RobloxProjectTemplate_Test.rbxl`
   - Open the `.rbxl` file in Roblox Studio
   - Run in Command Bar: `loadstring(game:GetService("ServerScriptService").TestRunner.Source)()`

2. **Windows/macOS Users**: Ensure `run-in-roblox` is properly installed and Roblox Studio is installed in the default location.

### Git Line Ending Issues

**Problem**: Files appear modified in Git even when unchanged, or scripts don't execute properly.

**Prevention**:
1. Create or update `.gitattributes` file:
   ```
   # Auto detect text files and perform LF normalization
   * text=auto
   
   # Explicitly declare files that should always have LF line endings
   *.sh text eol=lf
   *.lua text eol=lf
   *.json text eol=lf
   *.md text eol=lf
   ```

2. Normalize existing files:
   ```bash
   git add --renormalize .
   git commit -m "Normalize line endings"
   ```

### Development Server Issues

#### Development Server Won't Start

**Problem**: `./scripts/dev.sh` fails to start or throws errors

**Solutions**:
1. **Check if tools are installed**:
   ```bash
   rokit list
   ```

2. **Verify port availability**: Make sure port 34872 isn't already in use:
   ```bash
   # Kill any existing rojo processes
   pkill -f rojo
   ```

3. **Check for WSL file system issues**: If using WSL with Windows-mounted drives, try:
   ```bash
   # Convert script line endings
   dos2unix scripts/dev.sh
   ```

#### Live Sync Not Working

**Problem**: Changes to `src/` files don't appear in Roblox Studio

**Debugging steps**:
1. **Check if file watching is active**: You should see "Syncing and transforming files..." messages when editing files
2. **Verify Studio connection**: Ensure Roblox Studio is connected to `http://localhost:34872`
3. **Check file transformation**: Verify that `dist/` files are being updated:
   ```bash
   # Make a change to src/Common/Sum.lua, then check:
   cat dist/Common/Sum.lua
   ```

**Solutions**:
1. **WSL file system events**: On WSL with Windows-mounted drives, the development script uses timeout-based file watching which should work reliably
2. **Manual sync**: If automatic sync fails, you can manually trigger sync by stopping and restarting the dev server
3. **Check for errors**: Look for error messages in the terminal output

#### File Watching Performance

**Problem**: High CPU usage or delayed file sync

**Solutions**:
1. **Large projects**: The file watching uses `inotifywait` with 1-second timeouts, which is efficient
2. **Exclude unnecessary directories**: Edit the script to exclude large directories from watching
3. **Use native file system**: If using WSL, consider moving the project to the WSL file system (not `/mnt/c/`)

### Darklua Configuration Issues

**Problem**: "unknown source name" warnings for `@DevPackages` or `@Project` during build

**Cause**: Missing aliases in Darklua configuration or incorrect alias paths.

**Solution**: The template uses separate Darklua configurations for different environments:

**Production build** (`.darklua.json`):
- Uses `sourcemap.json` generated from `default.project.json`
- Aliases point to `dist/` paths (e.g., `@Common` → `dist/Common/`)
- Excludes test files
- Transforms aliases to full Roblox paths

**Development build** (`.darklua-dev.json`):
- Used by development server for live sync
- Transforms aliases properly for real-time development
- Processes `dist/` files in place for correct transformation

**Test build** (`.darklua-test.json`):
- Uses `test-sourcemap.json` generated from `test.project.json`  
- Aliases point to `test-dist/` paths (e.g., `@Common` → `test-dist/Common/`)
- Includes test files

**Problem**: Aliases not being transformed in development

**Cause**: Development configuration not processing files correctly

**Solution**: The development script now uses a two-step process:
1. Copy `src/` → `dist/`
2. Transform `dist/` → `dist/` with proper alias resolution

This ensures aliases are correctly transformed in development mode.

**Problem**: Sourcemap path warnings during build

**Cause**: This should not occur with the current template setup. All builds generate clean output.

**If you see warnings**:
1. Check that aliases in Darklua configs match the actual file paths
2. Ensure sourcemaps are generated BEFORE Darklua processing
3. Verify the correct Darklua config is used for each environment

### Wally Package Issues

**Problem**: Packages not found or outdated

**Solutions**:
1. Clean and reinstall packages:
   ```bash
   rm -rf Packages/ DevPackages/
   wally install
   ```

2. Check `wally.toml` for correct package versions

3. Verify `wally.lock` is up to date

**Problem**: "shared-packages" configuration error

**Solution**: Make sure `wally.toml` includes the `[place]` section:
```toml
[place]
shared-packages = "game.ReplicatedStorage.Packages"
```

### Rojo Build Issues

**Problem**: Build fails or produces incorrect structure

**Solutions**:
1. Check project file syntax:
   ```bash
   rojo build --help
   ```

2. Validate project structure:
   ```bash
   rojo sourcemap test.project.json
   ```

3. Clean build output:
   ```bash
   rm -f *.rbxl *.rbxlx sourcemap.json
   ```

## Getting Help

If you encounter issues not covered here:

1. Check the [Rokit documentation](https://github.com/rojo-rbx/rokit)
2. Check the [Rojo documentation](https://rojo.space/docs/)
3. Check the [Wally documentation](https://wally.run/)
4. Check the [Jest-Lua documentation](https://jsdotlua.github.io/jest-lua/)
5. Create an issue in the project repository