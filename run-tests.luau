-- Auto-run tests on game start
print("🧪 Starting Jest tests...")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local runCLI = require("@DevPackages/Jest").runCLI

local processServiceExists, ProcessService = pcall(function()
    return game:GetService("ProcessService")
end)

-- Configuration: Toggle these settings as needed
local VERBOSE_MODE = true  -- Set to false for summary-only output
local SHOW_STACK_TRACES = true  -- Set to false to hide stack traces
local CLEAR_MOCKS = true  -- Clear all mocks between tests
local PASS_WITH_NO_TESTS = true  -- Don't fail if no tests are found

local status, result = runCLI(ReplicatedStorage.Project, {
    verbose = VERBOSE_MODE,
    ci = true,  -- CI mode for cleaner output
    expand = true,  -- Show diff for each failing test
    noStackTrace = not SHOW_STACK_TRACES,  -- Control stack trace visibility
    clearMocks = CLEAR_MOCKS,  -- Clear mocks between tests
    passWithNoTests = PASS_WITH_NO_TESTS  -- Handle empty test suites gracefully
}, { ReplicatedStorage.Project }):awaitStatus()

if status == "Rejected" then
    print("❌ Tests failed:")
    print(result)
end

if status == "Resolved" then
    local results = result.results
    
    -- Calculate total time from individual test runtimes
    local totalTime = 0
    for _, testResult in ipairs(results.testResults) do
        totalTime = totalTime + (testResult.perfStats.runtime or 0)
    end
    totalTime = totalTime / 1000
    
    print("")
    print("==========================================")
    print("📊 TEST RESULTS SUMMARY")
    print("==========================================")
    print("Test Suites: " .. results.numPassedTestSuites .. " passed" .. 
          (results.numFailedTestSuites > 0 and ", " .. results.numFailedTestSuites .. " failed" or "") .. 
          ", " .. results.numTotalTestSuites .. " total")
    print("Tests:       " .. results.numPassedTests .. " passed" .. 
          (results.numFailedTests > 0 and ", " .. results.numFailedTests .. " failed" or "") .. 
          ", " .. results.numTotalTests .. " total")
    print("Time:        " .. string.format("%.3f", totalTime) .. "s")
    print("==========================================")
    
    -- Show detailed results for each test suite
    for _, testResult in ipairs(results.testResults) do
        local suiteName = testResult.testFilePath or "Unknown Suite"
        local suiteTime = (testResult.perfStats.runtime or 0) / 1000
        local status = (testResult.numFailingTests == 0) and "PASS" or "FAIL"
        local statusIcon = (status == "PASS") and "✅" or "❌"
        
        print("")
        print(statusIcon .. " " .. status .. " " .. suiteName .. " (" .. string.format("%.3f", suiteTime) .. "s)")
        
        -- Show individual test results if verbose or if there are failures
        if VERBOSE_MODE or testResult.numFailingTests > 0 then
            for _, test in ipairs(testResult.testResults) do
                local testStatus = test.status == "passed" and "✓" or "✗"
                local testTime = test.duration and (" (" .. test.duration .. "ms)") or ""
                print("  " .. testStatus .. " " .. test.title .. testTime)
                
                -- Show failure details
                if test.status ~= "passed" and test.failureMessages then
                    for _, message in ipairs(test.failureMessages) do
                        print("    💥 " .. tostring(message))
                    end
                end
            end
        end
    end
    
    print("")
    print("==========================================")
    
    -- Show any failed test details
    if results.numFailedTests > 0 then
        print("💔 FAILURE DETAILS")
        print("==========================================")
        for _, testResult in ipairs(results.testResults) do
            if testResult.numFailingTests > 0 then
                print("📁 " .. testResult.testFilePath)
                for _, test in ipairs(testResult.testResults) do
                    if test.status ~= "passed" then
                        print("  🔴 " .. test.fullName)
                        if test.failureMessages then
                            for _, message in ipairs(test.failureMessages) do
                                print("     " .. tostring(message))
                            end
                        end
                    end
                end
                print("")
            end
        end
        print("==========================================")
    end
    
    if results.numFailedTestSuites == 0 and results.numFailedTests == 0 then
        print("🎉 ALL TESTS PASSED!")
        if processServiceExists then
            ProcessService:ExitAsync(0)
        end
    else
        print("💥 " .. results.numFailedTests .. " TEST(S) FAILED")
        if processServiceExists then
            ProcessService:ExitAsync(1)
        end
    end
else
    print("❌ Tests failed to run:")
    print(result)
    if processServiceExists then
        ProcessService:ExitAsync(1)
    end
end