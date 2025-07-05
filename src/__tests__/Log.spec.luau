local JestGlobals = require("@DevPackages/JestGlobals")

local describe = JestGlobals.describe
local it = JestGlobals.it
local expect = JestGlobals.expect

local Log = require("@Project/Common/Log")

describe("Log", function()
    it("should have debug, info, and warn methods", function()
        expect(type(Log.debug)).toBe("function")
        expect(type(Log.info)).toBe("function")
        expect(type(Log.warn)).toBe("function")
    end)
    
    it("should call debug function without errors", function()
        expect(function()
            Log.debug("Test debug message")
        end).never.toThrow()
    end)
    
    it("should call info function without errors", function()
        expect(function()
            Log.info("Test info message")
        end).never.toThrow()
    end)
    
    it("should call warn function without errors", function()
        expect(function()
            Log.warn("Test warn message")
        end).never.toThrow()
    end)
end)