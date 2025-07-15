-- Configuration utility for loading project config
local fs = require("@lune/fs")
local serde = require("@lune/serde")

local Config = {}

function Config.load()
    local config = {
        PROJECT_NAME = "RobloxProjectTemplate",
        JEST_VERBOSE = "true",
        JEST_CI = "false",
        ROBLOX_TEST_PLACE_ID = "",
        ROBLOX_TEST_UNIVERSE_ID = "",
        ROBLOX_API_KEY = ""
    }
    
    -- Read TOML config file
    if fs.isFile("project.config.toml") then
        local tomlContent = fs.readFile("project.config.toml")
        local tomlConfig = serde.decode("toml", tomlContent)
        
        -- Map TOML structure to flat config
        if tomlConfig.project and tomlConfig.project.name and tomlConfig.project.name ~= "" then
            config.PROJECT_NAME = tomlConfig.project.name
        end
        
        if tomlConfig.test then
            if tomlConfig.test.verbose ~= nil then
                config.JEST_VERBOSE = tostring(tomlConfig.test.verbose)
            end
            if tomlConfig.test.ci ~= nil then
                config.JEST_CI = tostring(tomlConfig.test.ci)
            end
        end
        
        if tomlConfig.cloud then
            if tomlConfig.cloud.test_place_id and tomlConfig.cloud.test_place_id ~= "" then
                config.ROBLOX_TEST_PLACE_ID = tomlConfig.cloud.test_place_id
            end
            if tomlConfig.cloud.test_universe_id and tomlConfig.cloud.test_universe_id ~= "" then
                config.ROBLOX_TEST_UNIVERSE_ID = tomlConfig.cloud.test_universe_id
            end
            if tomlConfig.cloud.api_key and tomlConfig.cloud.api_key ~= "" then
                config.ROBLOX_API_KEY = tomlConfig.cloud.api_key
            end
        end
    end
    
    return config
end

return Config