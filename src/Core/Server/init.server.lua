local ReplicatedFirst = game:GetService("ReplicatedScriptService")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

-- Initialize Cardinal

repeat wait() until shared.Deus
local Deus = shared.Deus()
local CardinalCore = script.Parent

local CardinalClient = CardinalCore.Client
local CardinalShared = CardinalCore.Shared

CardinalShared:Clone().Parent = CardinalClient
CardinalClient.Parent = ReplicatedFirst

Deus:Register(script, "Cardinal")
Deus:Register(CardinalShared, "Cardinal")

shared.Deus = nil
shared.Cardinal = Deus:Load("Cardinal.CardinalLoader").new()

-- Sort Modules

local ServerModules = Instance.new("Folder")
ServerModules.Name = "CardinalModules"

local ClientModules = Instance.new("Folder")
ClientModules.Name = "CardinalModules"

local function SortModules(modules)
    for _,module in pairs(modules) do

        if module:IsA("Folder") then

            if module.Name:lower() == "server" then
                module:Clone().Parent = ServerModules
            elseif module.Name:lower() == "client" then
                module:Clone().Parent = ClientModules
            elseif module.Name:lower() == "shared" then
                module:Clone().Parent = ServerModules
                module:Clone().Parent = ClientModules
            else
                SortModules(module:GetChildren())
            end

        elseif module:IsA("ModuleScript") then
            module:Clone().Parent = ServerModules
            module:Clone().Parent = ClientModules
        elseif module:IsA("LocalScript") then
            module:Clone().Parent = ClientModules
        elseif module:IsA("Script") then
            module:Clone().Parent = ServerModules
        end

    end
end

local Modules = ServerStorage:WaitForChild("CardinalModules")
if Modules then
    SortModules(Modules:GetChildren())
end

ServerModules.Parent = ServerScriptService
ClientModules.Parent = ReplicatedFirst

-- Initialize Modules

for _,module in pairs(ServerModules:GetChildren()) do
    if module:IsA("Folder") then
        Deus:Register(module, module.Name)
    end
end