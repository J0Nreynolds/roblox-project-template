-- Build production project
local fs = require("@lune/fs")
local process = require("@lune/process")

local Config = require("./lib/config")
local ProcessUtil = require("./lib/process")

print("📦 Building project...")

local config = Config.load()

-- If Packages aren't installed, install them
if not fs.isDir("Packages") then
    print("Packages not found, installing...")
    if not ProcessUtil.run("lune", {"run", "install"}) then
        process.exit(1)
    end
end

-- Clean and create dist directory
if fs.isDir("dist") then
    fs.removeDir("dist")
end

-- Generate sourcemap for src/
if not ProcessUtil.run("rojo", {"sourcemap", "default.project.json", "-o", "sourcemap.json"}) then
    process.exit(1)
end

-- Process files from src/ to dist/
if not ProcessUtil.run("darklua", {"process", "--config", ".darklua.json", "src/", "dist/"}, {
    ROBLOX_DEV = "false"
}) then
    process.exit(1)
end

-- Build final project from dist/
local productionPlaceFile = `{config.PROJECT_NAME}.rbxl`
if not ProcessUtil.run("rojo", {"build", "build.project.json", "-o", productionPlaceFile}) then
    process.exit(1)
end

print(`✅ Successfully built production place: {productionPlaceFile}`)