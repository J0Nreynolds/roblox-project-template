-- Development server with file watching
local fs = require("@lune/fs")
local process = require("@lune/process")
local task = require("@lune/task")

local Config = require("./lib/config")
local ProcessUtil = require("./lib/process")

print("🚀 Starting development server...")

local config = Config.load()

-- If Packages aren't installed, install them
if not fs.isDir("Packages") then
    print("Packages not found, installing...")
    if not ProcessUtil.run("lune", {"run", "install"}) then
        process.exit(1)
    end
end

-- Initial setup: clean dist and generate sourcemap
if fs.isDir("dist") then
    fs.removeDir("dist")
end

if not ProcessUtil.run("rojo", {"sourcemap", "default.project.json", "-o", "sourcemap.json"}) then
    process.exit(1)
end

-- Initial processing with correct aliases
if not ProcessUtil.run("darklua", {"process", "--config", ".darklua.json", "src/", "dist/"}, {
    ROBLOX_DEV = "true"
}) then
    process.exit(1)
end

print("Starting file watching processes...")

-- Start processes in background
local rojoChild = ProcessUtil.create("rojo", {"serve", "build.project.json"})
local sourcemapChild = ProcessUtil.create("rojo", {"sourcemap", "default.project.json", "-o", "sourcemap.json", "--watch"})
local darkluaChild = ProcessUtil.create("darklua", {"process", "--config", ".darklua.json", "--watch", "src/", "dist/"}, {
    ROBLOX_DEV = "true"
})

print("Development server running. Press Ctrl+C to stop.")

-- Wait for any process to exit (this blocks)
local rojoStatus = rojoChild:status()
if not rojoStatus.ok then
    print("❌ Rojo serve failed")
    process.exit(rojoStatus.code)
end