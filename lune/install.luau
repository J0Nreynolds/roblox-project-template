-- Install tools and packages
local fs = require("@lune/fs")
local process = require("@lune/process")

local ProcessUtil = require("./lib/process")

local function checkCommand(command: string): boolean
    local result = process.exec(command, {"--version"}, {
        stdio = "none"
    })
    return result.ok
end

-- Install tools with Rokit (if available)
if checkCommand("rokit") then
    print("Installing tools with Rokit...")
    if not ProcessUtil.run("rokit", {"install"}) then
        process.exit(1)
    end
else
    print("Rokit not found. Please install Rokit: https://github.com/rojo-rbx/rokit")
    print("Or ensure tools are available in PATH manually.")
end

-- Install packages with Wally
if not ProcessUtil.run("wally", {"install"}) then
    process.exit(1)
end

-- Patch the Wally package link modules to also export Luau type definitions
if not ProcessUtil.run("rojo", {"sourcemap", "default.project.json", "-o", "sourcemap.json"}) then
    process.exit(1)
end

if not ProcessUtil.run("wally-package-types", {"--sourcemap", "sourcemap.json", "Packages/"}) then
    process.exit(1)
end

print("✅ Installation completed successfully!")