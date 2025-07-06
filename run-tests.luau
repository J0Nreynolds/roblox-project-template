local ReplicatedStorage = game:GetService("ReplicatedStorage")

local runCLI = require("@DevPackages/Jest").runCLI
-- Disabling chalk makes test output easier to read in Studio console
if __STUDIO__ == "true" then
	_G.NOCOLOR = true
end

local processServiceExists, ProcessService = pcall(function()
	return game:GetService("ProcessService")
end)
local status, result = runCLI(ReplicatedStorage.Project, {
	verbose = __VERBOSE__ == "true",
	ci = __CI__ == "true",
}, { ReplicatedStorage.Project }):awaitStatus()

if status == "Rejected" then
	print(result)
end

if status == "Resolved" and result.results.numFailedTestSuites == 0 and result.results.numFailedTests == 0 then
	if processServiceExists then
		ProcessService:ExitAsync(0)
	end
end

if processServiceExists then
	ProcessService:ExitAsync(1)
end

return nil
