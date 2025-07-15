-- Helper script to run tests via PowerShell for WSL/Linux environments
local process = require("@lune/process")

print("🔄 Running tests via PowerShell (for run-in-roblox support)...")
print("")

-- Get the Windows path for the current directory
local currentPath = process.cwd
local windowsPath = currentPath:gsub("/mnt/c", "C:"):gsub("/", "\\")

-- Create PowerShell command
local powershellScript = `Set-Location '{windowsPath}'; lune run test`

-- Run test commands through PowerShell
local result = process.exec("powershell.exe", { "-Command", powershellScript }, {
	stdio = "inherit",
})

print("")
if result.ok then
	print("✅ PowerShell test execution completed")
	process.exit(0)
else
	print("❌ PowerShell test execution failed")
	print("")
	print("💡 If you see socket access permission errors, restart Windows Host Network Service")
	print("   in admin PowerShell: net stop hns; net start hns")
	process.exit(result.code)
end
