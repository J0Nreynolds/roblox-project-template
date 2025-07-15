-- Build test project
local fs = require("@lune/fs")
local process = require("@lune/process")

local Config = require("./lib/config")
local ProcessUtil = require("./lib/process")

print("📦 Building test project...")

local config = Config.load()

-- If Packages aren't installed, install them
if not fs.isDir("Packages") or not fs.isDir("DevPackages") then
    print("Packages not found, installing...")
    if not ProcessUtil.run("lune", {"run", "install"}) then
        process.exit(1)
    end
end

-- Clean test dist directory
if fs.isDir("dist") then
    fs.removeDir("dist")
end

-- Generate sourcemap for test src files (includes test files and runner)
if not ProcessUtil.run("rojo", {"sourcemap", "default.test.project.json", "-o", "sourcemap.test.json"}) then
    process.exit(1)
end

-- Process files from src/ to dist/
if not ProcessUtil.run("darklua", {"process", "--config", ".darklua.test.json", "src/", "dist/"}, {
    TEST_IN_STUDIO = "false",
    JEST_VERBOSE = config.JEST_VERBOSE,
    JEST_CI = config.JEST_CI
}) then
    process.exit(1)
end

-- Process test runner
if not ProcessUtil.run("darklua", {"process", "--config", ".darklua.test.json", "run-tests.luau", "test_runner/run-tests.luau"}, {
    TEST_IN_STUDIO = "false",
    JEST_VERBOSE = config.JEST_VERBOSE,
    JEST_CI = config.JEST_CI
}) then
    process.exit(1)
end

-- Build test project
local testPlaceFile = `{config.PROJECT_NAME}_Test.rbxl`
if not ProcessUtil.run("rojo", {"build", "build.test.project.json", "--output", testPlaceFile}) then
    process.exit(1)
end

print(`✅ Successfully built test project: {testPlaceFile}`)