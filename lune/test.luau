-- Build and run tests
local process = require("@lune/process")

local Config = require("./lib/config")
local ProcessUtil = require("./lib/process")

local config = Config.load()

-- Build test project
print("🧪 Building test project...")
if not ProcessUtil.run("lune", { "run", "build-test" }) then
	process.exit(1)
end

local testPlaceFile = `{config.PROJECT_NAME}_Test.rbxl`
print(testPlaceFile)
-- Try to run tests with run-in-roblox, but handle errors gracefully
print("Attempting to run Jest tests...")

local result = process.exec("run-in-roblox", { "--place", testPlaceFile, "--script", "test_runner/run-tests.luau" }, {
	stdio = "inherit",
})

if result.ok then
	print("Tests completed successfully!")
	process.exit(0)
else
	print("")
	print("❌ run-in-roblox failed or is not supported on this platform.")
	print("")
	print("📋 To run tests in Roblox Studio:")
	print(`1. Open {testPlaceFile} in Roblox Studio`)
	print("2. Run tests via Command Bar: loadstring(game:GetService('ServerScriptService').TestRunner.Source)()")
	print("3. Check the output window for test results")
	print("")
	print("ℹ️  For CI/automation, install run-in-roblox on Windows/macOS runners")
	process.exit(1)
end
