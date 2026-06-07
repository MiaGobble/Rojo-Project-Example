local net = require("@lune/net")
local fs = require("@lune/fs")
local process = require("@lune/process")

-- Pull from GitHub Environment Variables
local API_KEY = process.env.ROBLOX_API_KEY
local UNIVERSE_ID = process.env.UNIVERSE_ID
local PLACE_ID = process.env.PLACE_ID
local FILE_PATH = "build.rbxl"

if not fs.isFile(FILE_PATH) then
    error("Build failed: " .. FILE_PATH .. " not found")
end

local fileContents = fs.readFile(FILE_PATH)

print("Publishing to Roblox...")

local response = net.request({
    url = string.format(
        "https://apis.roblox.com/universes/v1/%s/places/%s/versions?versionType=Published", 
        UNIVERSE_ID, 
        PLACE_ID
    ),
    method = "POST",
    headers = {
        ["x-api-key"] = API_KEY,
        ["Content-Type"] = "application/octet-stream",
        ["Content-Length"] = tostring(#fileContents),
    },
    body = fileContents,
})

if response.ok then
    print("Successfully published! Version: " .. response.body)
else
    print("Error " .. response.statusCode .. ": " .. response.body)
    process.exit(1) -- Fails the GitHub Action if the upload fails
end