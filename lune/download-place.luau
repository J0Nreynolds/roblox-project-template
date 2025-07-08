local downloadPlaceAsset = require("./lib/downloadPlaceAsset")
local fs = require("@lune/fs")
local process = require("@lune/process")

if process.env.ROBLOX_PLACE_ID == nil then
	error("ROBLOX_PLACE_ID environment variable is not set")
end

local content = downloadPlaceAsset(process.env.ROBLOX_PLACE_ID)
fs.writeFile("./game.rbxl", content)
