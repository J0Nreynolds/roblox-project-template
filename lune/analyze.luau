-- Run type analysis
local fs = require("@lune/fs")
local net = require("@lune/net")
local process = require("@lune/process")

local ProcessUtil = require("./lib/process")

-- If Packages aren't installed, install them
if not fs.isDir("Packages") then
    print("Packages not found, installing...")
    if not ProcessUtil.run("lune", {"run", "install"}) then
        process.exit(1)
    end
end

-- Generate sourcemap
if not ProcessUtil.run("rojo", {"sourcemap", "default.project.json", "-o", "sourcemap.json"}) then
    process.exit(1)
end

-- Download global types if not present
if not fs.isFile("globalTypes.d.luau") then
    print("Downloading global types...")
    local response = net.request("https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/main/scripts/globalTypes.d.luau")
    if response.ok then
        fs.writeFile("globalTypes.d.luau", response.body)
    else
        print("❌ Failed to download global types")
        process.exit(1)
    end
end

print("Running type analysis...")

-- Run luau-lsp analysis
local result = process.exec("luau-lsp", {
    "analyze",
    "--definitions=globalTypes.d.luau",
    "--base-luaurc=src/.luaurc",
    "--sourcemap=sourcemap.json",
    "--settings=.vscode/settings.json",
    "--no-strict-dm-types",
    "--ignore", "Packages/**/*.lua",
    "--ignore", "Packages/**/*.luau",
    "--ignore", "DevPackages/**/*.lua", 
    "--ignore", "DevPackages/**/*.luau",
    "--ignore", "lib/**/*.lua",
    "--ignore", "lib/**/*.luau",
    "src/"
}, {
    stdio = "inherit"
})

if result.ok then
    print("✅ Type analysis passed - no issues found!")
    process.exit(0)
else
    print("❌ Type analysis failed - see errors above")
    process.exit(1)
end