-- Cloud-based testing using Roblox Open Cloud API
local process = require("@lune/process")

local Config = require("./lib/config")
local ProcessUtil = require("./lib/process")

print("🌩️  Running tests via Roblox Open Cloud...")

local config = Config.load()

-- Check required environment variables
local apiKey = process.env.ROBLOX_API_KEY or config.ROBLOX_API_KEY
local universeId = process.env.ROBLOX_TEST_UNIVERSE_ID or config.ROBLOX_TEST_UNIVERSE_ID
local placeId = process.env.ROBLOX_TEST_PLACE_ID or config.ROBLOX_TEST_PLACE_ID

if not apiKey then
	print("❌ ROBLOX_API_KEY environment variable or config value required")
	process.exit(1)
end

if not universeId then
	print("❌ ROBLOX_TEST_UNIVERSE_ID environment variable or config value required")
	process.exit(1)
end

if not placeId then
	print("❌ ROBLOX_TEST_PLACE_ID environment variable or config value required")
	process.exit(1)
end

-- Build test project
if not ProcessUtil.run("lune", { "run", "build-test" }) then
	process.exit(1)
end

local testPlaceFile = `{config.PROJECT_NAME}_Test.rbxl`

print("☁️  Uploading and executing tests via Open Cloud...")

-- Check for Python and run cloud test script
local pythonResult = process.exec("python3", { "--version" }, { stdio = "none" })
local pythonCommand = "python3"

if not pythonResult.ok then
	local pythonResult2 = process.exec("python", { "--version" }, { stdio = "none" })
	if pythonResult2.ok then
		pythonCommand = "python"
	else
		print("❌ Python not found. Please install Python 3")
		process.exit(1)
	end
end

-- Execute cloud tests
local result = process.exec(
	pythonCommand,
	{ "./python/upload_and_run_task.py", testPlaceFile, "test_runner/run-tests.luau" },
	{
		env = {
			ROBLOX_API_KEY = apiKey,
			ROBLOX_UNIVERSE_ID = universeId,
			ROBLOX_PLACE_ID = placeId,
		},
		stdio = "inherit",
	}
)

if result.ok then
	print("✅ Cloud test execution completed")
	process.exit(0)
else
	print("❌ Cloud test execution failed")
	process.exit(result.code)
end
