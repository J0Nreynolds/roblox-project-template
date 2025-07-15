-- Test development server with file watching
local fs = require("@lune/fs")
local process = require("@lune/process")
local task = require("@lune/task")

local Config = require("./lib/config")
local ProcessUtil = require("./lib/process")

local config = Config.load()

-- If Packages aren't installed, install them
if not fs.isDir("Packages") or not fs.isDir("DevPackages") then
    print("Packages not found, installing...")
    if not ProcessUtil.run("lune", {"run", "install"}) then
        process.exit(1)
    end
end

-- Initial setup: clean and generate sourcemap
if fs.isDir("dist") then
    fs.removeDir("dist")
end

if not ProcessUtil.run("rojo", {"sourcemap", "default.test.project.json", "-o", "sourcemap.test.json"}) then
    process.exit(1)
end

-- Initial processing
if not ProcessUtil.run("darklua", {"process", "--config", ".darklua.test.json", "src/", "dist/"}, {
    TEST_IN_STUDIO = "true"
}) then
    process.exit(1)
end

if not ProcessUtil.run("darklua", {"process", "--config", ".darklua.test.json", "run-tests.luau", "test_runner/run-tests.luau"}, {
    TEST_IN_STUDIO = "true"
}) then
    process.exit(1)
end

-- Build test project
local testPlaceFile = `{config.PROJECT_NAME}_Test.rbxl`
if not ProcessUtil.run("rojo", {"build", "build.test.project.json", "--output", testPlaceFile}) then
    process.exit(1)
end

print(`✅ Successfully built test project: {testPlaceFile}`)

print("Starting test development server...")
print("- Run tests via Command Bar: loadstring(game:GetService('ServerScriptService').TestRunner.Source)()")
print("- File watching enabled for test development")
print("- Server available at http://localhost:34872")

-- Start processes in background
local rojoChild = ProcessUtil.create("rojo", {"serve", "build.test.project.json"})
local sourcemapChild = ProcessUtil.create("rojo", {"sourcemap", "default.test.project.json", "-o", "sourcemap.test.json", "--watch"})
local darkluaSrcChild = ProcessUtil.create("darklua", {"process", "--watch", "--config", ".darklua.test.json", "src/", "dist/"}, {
    TEST_IN_STUDIO = "true"
})
local darkluaRunnerChild = ProcessUtil.create("darklua", {"process", "--watch", "--config", ".darklua.test.json", "run-tests.luau", "test_runner/run-tests.luau"}, {
    TEST_IN_STUDIO = "true"
})

print("Test development server running. Press Ctrl+C to stop.")

-- Wait for any process to exit (this blocks)
local rojoStatus = rojoChild:status()
if not rojoStatus.ok then
    print("❌ Rojo serve failed")
    process.exit(rojoStatus.code)
end