local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local process = require("@lune/process")

print("Starting build pipeline...")

-- Build source code into file
local rojoBuild = process.exec("rojo", { "build", "default.project.json", "-o", "temp_sync.rbxm" }, { shell = true })

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

-- Merge files
print("Merging Rojo assets into DataModel...")

for _, serviceFolder in syncModel:GetChildren() do
    local targetService = game:GetService(serviceFolder.Name)
    
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

-- Write and cleanup
local finalPlaceBuffer = roblox.serializePlace(game)
fs.writeFile("build.rbxl", finalPlaceBuffer)

if fs.isFile("temp_sync.rbxm") then
    fs.removeFile("temp_sync.rbxm")
end

print("Successfully generated build.rbxl")