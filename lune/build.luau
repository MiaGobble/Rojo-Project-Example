--!strict

--[[
    This script builds the Roblox project by doing two things:
    1. Creating a temporary build file from the Rojo project
    2. Merging the Rojo project with game.rbxlx for a final build.rbxl

    When syncing code to a local file, *always* do it to build.rbxl. This ensures version control doesn't screw up.

    While more complicated for building, we opt to use rbxl instead of rbxlx for the final build file. This is because it reads, writes, and publishes much faster than the XML format.

    The reason we even build games this way is because of two reasons:
    1. It makes editing and implementing assets much easier, and
    2. It fixes bugs that would otherwise be caused by Rojo building

    R15 avatar settings can be toggled using the IS_R15_ENABLED constant. If you want to change specific properties, you can modify the code block that implements the R15 properties accordingly.
    Do note that the R15-related settings only take effect on the local build, and do not affect the published game.

    CollectionService tags (including multi-tag instances, which are null-separated
    in the file format) are preserved by Lune's place deserializer as of 0.10.5 —
    no XML rewriting is required.
]]

-- Constants
local IS_R15_ENABLED = true -- If true, build will have players join as R15 avatars

-- Imports
local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local process = require("@lune/process")

print("Starting build pipeline...")

-- Build source code into file
local rojoBuild = process.exec("rojo", {
    "build",
    "default.project.json",
    "-o",
    "temp_sync.rbxm"
}, {})

if not rojoBuild.ok then
    print("Rojo build failed: " .. rojoBuild.stderr)
    process.exit(1)
end

-- Load main build file
if not fs.isFile("game.rbxlx") then
    print("Error: 'game.rbxlx' template file not found. Save your game setup to the root first!")
    process.exit(1)
end

local baseFileBuffer = fs.readFile("game.rbxlx")
local syncFileBuffer = fs.readFile("temp_sync.rbxm")

local game = roblox.deserializePlace(baseFileBuffer)
local syncModel = roblox.deserializeModel(syncFileBuffer)[1]

if syncModel == nil then
    print("Error: Rojo sync model was empty")
    process.exit(1)
end

-- Merge files
print("Merging Rojo assets into DataModel...")

for _, serviceFolder in syncModel:GetChildren() do
    local targetService = game:FindService(serviceFolder.Name)

    if targetService then
        for _, incomingAsset in serviceFolder:GetChildren() do
            local existingConflict = targetService:FindFirstChild(incomingAsset.Name)

            if existingConflict then
                print(`Removing old Rojo asset: {serviceFolder.Name}/{incomingAsset.Name}`)
                existingConflict:Destroy()
            end

            incomingAsset.Parent = targetService
        end
    else
        print("Warning: Service '" .. serviceFolder.Name .. "' not found in place file.")
    end
end

-- Change properties
if IS_R15_ENABLED then
    -- Change the properties in here for R15 stuff
    print("Implementing R15 properties...")

    -- Lune Instance types do not expose class-specific properties; cast for StarterPlayer fields.
    local starterPlayer = game:GetService("StarterPlayer") :: any
    starterPlayer.GameSettingsAvatar = (roblox :: any).Enum.GameAvatarType.R15
    starterPlayer.GameSettingsScaleRangeBodyType = (roblox :: any).NumberRange.new(1, 1)
    starterPlayer.GameSettingsScaleRangeHead = (roblox :: any).NumberRange.new(1, 1)
    starterPlayer.GameSettingsScaleRangeHeight = (roblox :: any).NumberRange.new(5, 5)
end

-- Write and cleanup
local finalPlaceBuffer = roblox.serializePlace(game)
fs.writeFile("build.rbxl", finalPlaceBuffer)

if fs.isFile("temp_sync.rbxm") then
    fs.removeFile("temp_sync.rbxm")
end

print("Successfully generated build.rbxl")
