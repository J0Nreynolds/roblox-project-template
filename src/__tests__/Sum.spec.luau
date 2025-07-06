local JestGlobals = require("@DevPackages/JestGlobals")

local describe = JestGlobals.describe
local it = JestGlobals.it
local expect = JestGlobals.expect

local _inspect = require("@lib/inspect")
local sum = require("@Project/Common/Sum")

describe("Sum", function()
	it("adds 1 + 2 to equal 3", function()
		expect(sum(1, 2)).toBe(3)
	end)

	it("handles negative numbers", function()
		expect(sum(-1, 1)).toBe(0)
		expect(sum(-1, -2)).toBe(-3)
	end)

	it("handles zero", function()
		expect(sum(0, 0)).toBe(0)
		expect(sum(5, 0)).toBe(5)
	end)
end)
