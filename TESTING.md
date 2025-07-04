# Testing Guide

This guide covers how to write and run tests for your Roblox project using Jest-Lua.

## Setup

Jest-Lua is already configured in this template. The setup includes:

- **Jest**: Core testing framework
- **JestGlobals**: Test globals (describe, it, expect, etc.)
- **jest.config.lua**: Test configuration
- **run-tests.lua**: Test runner script

## Writing Tests

### Test File Structure

Tests should be placed in `src/__tests__/` and follow the naming pattern `*.spec.lua`.

```
src/
├── __tests__/
│   ├── Sum.spec.lua
│   ├── Log.spec.lua
│   └── MyModule.spec.lua
└── Common/
    ├── Sum.lua
    └── Log.lua
```

### Basic Test Structure

```lua
local JestGlobals = require("@DevPackages/JestGlobals")

local describe = JestGlobals.describe
local it = JestGlobals.it
local expect = JestGlobals.expect

local myModule = require("@Project/Common/MyModule")

describe("MyModule", function()
    it("should do something", function()
        expect(myModule.doSomething()).toBe(true)
    end)
end)
```

### Common Matchers

```lua
-- Equality
expect(value).toBe(expected)
expect(value).toEqual(expected)

-- Truthiness
expect(value).toBeTruthy()
expect(value).toBeFalsy()

-- Numbers
expect(value).toBeGreaterThan(3)
expect(value).toBeGreaterThanOrEqual(3)
expect(value).toBeLessThan(5)
expect(value).toBeLessThanOrEqual(5)

-- Strings
expect(string).toMatch("pattern")

-- Arrays/Tables
expect(array).toContain(item)
expect(array).toHaveLength(3)

-- Functions
expect(fn).toThrow()
expect(fn).toThrow("error message")

-- Negation
expect(value).never.toBe(expected)
```

### Testing Async Code

```lua
it("should handle promises", function()
    return expect(asyncFunction()).resolves.toBe(expectedValue)
end)

it("should handle promise rejections", function()
    return expect(asyncFunction()).rejects.toMatch("error")
end)
```

### Setup and Teardown

```lua
describe("MyModule", function()
    local originalValue
    
    beforeEach(function()
        originalValue = someGlobalValue
        someGlobalValue = testValue
    end)
    
    afterEach(function()
        someGlobalValue = originalValue
    end)
    
    it("should work with setup", function()
        expect(myModule.useGlobalValue()).toBe(testValue)
    end)
end)
```

## Running Tests

### Command Line (Windows/macOS)

```bash
# Run all tests
./scripts/test.sh

# Run with verbose output
run-in-roblox --place RobloxProjectTemplate_Test.rbxl --script run-tests.lua
```

**Note**: Command line testing requires `run-in-roblox` and doesn't work in WSL. For WSL users, use Roblox Studio instead.

### Roblox Studio

1. Build the test project:
   ```bash
   rojo build test.project.json --output RobloxProjectTemplate_Test.rbxl
   ```

2. Open `RobloxProjectTemplate_Test.rbxl` in Roblox Studio

3. In the Command Bar, run:
   ```lua
   loadstring(game:GetService("ServerScriptService").TestRunner.Source)()
   ```

4. Check the output window for test results

### Required Setup for Studio

To run tests in Roblox Studio, you need to enable the LoadModule flag:

1. Create `ClientAppSettings.json` in your Roblox settings folder
2. Add the following content:

```json
{
    "FFlagEnableLoadModule": true
}
```

## Test Examples

### Testing a Utility Function

```lua
-- src/Common/MathUtils.lua
local MathUtils = {}

function MathUtils.add(a, b)
    return a + b
end

function MathUtils.clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

return MathUtils
```

```lua
-- src/__tests__/MathUtils.spec.lua
local JestGlobals = require("@DevPackages/JestGlobals")

local describe = JestGlobals.describe
local it = JestGlobals.it
local expect = JestGlobals.expect

local MathUtils = require("@Project/Common/MathUtils")

describe("MathUtils", function()
    describe("add", function()
        it("should add two positive numbers", function()
            expect(MathUtils.add(2, 3)).toBe(5)
        end)
        
        it("should handle negative numbers", function()
            expect(MathUtils.add(-1, 1)).toBe(0)
        end)
    end)
    
    describe("clamp", function()
        it("should clamp values within range", function()
            expect(MathUtils.clamp(5, 0, 10)).toBe(5)
            expect(MathUtils.clamp(-5, 0, 10)).toBe(0)
            expect(MathUtils.clamp(15, 0, 10)).toBe(10)
        end)
    end)
end)
```

### Testing a Service

```lua
-- src/Server/Services/DataService.lua
local DataService = {}

function DataService.savePlayerData(player, data)
    -- Implementation
    return true
end

return DataService
```

```lua
-- src/__tests__/DataService.spec.lua
local JestGlobals = require("@DevPackages/JestGlobals")

local describe = JestGlobals.describe
local it = JestGlobals.it
local expect = JestGlobals.expect

local DataService = require("@Project/Server/Services/DataService")

describe("DataService", function()
    it("should save player data", function()
        local mockPlayer = { Name = "TestPlayer" }
        local mockData = { coins = 100 }
        
        expect(DataService.savePlayerData(mockPlayer, mockData)).toBe(true)
    end)
end)
```

## Best Practices

1. **Descriptive Test Names**: Use clear, descriptive names for your tests
2. **One Assertion Per Test**: Keep tests focused on a single behavior
3. **Test Edge Cases**: Include tests for boundary conditions and error cases
4. **Use Setup/Teardown**: Clean up after tests to avoid side effects
5. **Mock External Dependencies**: Use mocks for external services or APIs
6. **Test Public Interface**: Focus on testing the public API of your modules

## Troubleshooting

### Common Issues

1. **Module Not Found**: Ensure the module path is correct and uses `@Project/` prefix
2. **FFlagEnableLoadModule**: Make sure the flag is enabled in ClientAppSettings.json
3. **Test Not Running**: Check that the test file ends with `.spec.lua`
4. **Assertion Errors**: Use the correct matcher for your test case

### Debug Output

Add debug output to your tests:

```lua
it("should debug something", function()
    local result = myFunction()
    print("Result:", result)
    expect(result).toBe(expected)
end)
```

For more information, see the [Jest-Lua documentation](https://jsdotlua.github.io/jest-lua/).