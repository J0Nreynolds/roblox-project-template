-- Process utility for running commands
local process = require("@lune/process")

local ProcessUtil = {}

function ProcessUtil.run(command: string, args: {string}?, env: {[string]: string}?): boolean
    print(`Running: {command} {table.concat(args or {}, " ")}`)
    
    local spawnEnv = {}
    for key, value in pairs(process.env) do
        spawnEnv[key] = value
    end
    if env then
        for key, value in pairs(env) do
            spawnEnv[key] = value
        end
    end
    
    local result = process.exec(command, args, {
        env = spawnEnv,
        stdio = "inherit"
    })
    
    if not result.ok then
        print(`❌ Command failed: {command}`)
        return false
    end
    
    return true
end

function ProcessUtil.create(command: string, args: {string}?, env: {[string]: string}?)
    local spawnEnv = {}
    for key, value in pairs(process.env) do
        spawnEnv[key] = value
    end
    if env then
        for key, value in pairs(env) do
            spawnEnv[key] = value
        end
    end
    
    return process.create(command, args, {
        env = spawnEnv
    })
end

return ProcessUtil
