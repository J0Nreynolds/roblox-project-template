local downloadPlaceAsset = require("./lib/downloadPlaceAsset")
local fs = require("@lune/fs")
local process = require("@lune/process")
local roblox = require("@lune/roblox")

if process.env.ROBLOX_PLACE_ID == nil then
	error("ROBLOX_PLACE_ID environment variable is not set")
end

local content = downloadPlaceAsset(process.env.ROBLOX_PLACE_ID) -- replace with your own place id!
local game = roblox.deserializePlace(content)

if not fs.isDir("./map") then
	fs.writeDir("./map")
end

if not fs.isDir("./assets") then
	fs.writeDir("./assets")
end

fs.writeFile("./map/Workspace.rbxm", roblox.serializeModel(game.Workspace))
fs.writeFile("./map/Lighting.rbxm", roblox.serializeModel(game.Lighting))
fs.writeFile(`./assets/Models.rbxm`, roblox.serializeModel(game.ReplicatedStorage.Assets))
