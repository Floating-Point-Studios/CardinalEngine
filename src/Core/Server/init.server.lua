local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

-- Initialize Cardinal

repeat wait() until shared.Deus
local Deus = shared.Deus
local CardinalCore = script.Parent

local StringUtils = Deus:Load("Deus.StringUtils")

local CardinalClient = CardinalCore.Client
local CardinalShared = CardinalCore.Shared

CardinalShared:Clone().Parent = CardinalClient
CardinalClient.Parent = ReplicatedFirst

Deus:Register(script, "Cardinal")
Deus:Register(CardinalShared, "Cardinal")

shared.Cardinal = Deus:Load("Cardinal.CardinalLoader").new().Proxy
-- shared.Deus = nil

-- Sort Modules

local ServerModules = Instance.new("Folder")
ServerModules.Name = "CardinalModules"

local ClientModules = Instance.new("Folder")
ClientModules.Name = "CardinalModules"

local function SortModules(modules)
    for _,module in pairs(modules) do

        if module:IsA("Folder") then

            local moduleName = module.Name
            if moduleName:lower() == "server" then

                module = module:Clone()
                module.Name = module.Parent.Name
                module.Parent = ServerModules

            elseif moduleName:lower() == "client" then

                module = module:Clone()
                module.Name = module.Parent.Name
                module.Parent = ClientModules

            elseif moduleName:lower() == "shared" then

                module = module:Clone()
                module.Name = module.Parent.Name
                module.Parent = ServerModules
                module:Clone().Parent = ClientModules

            elseif StringUtils.reverseSub(moduleName, 1, 7):lower() == ".server" then

                module = module:Clone()
                module.Name = StringUtils.reverseSub(moduleName, 8)
                module.Parent = ServerModules

            elseif StringUtils.reverseSub(moduleName, 1, 7):lower() == ".client" then

                module = module:Clone()
                module.Name = StringUtils.reverseSub(moduleName, 8)
                module.Parent = ClientModules

            elseif StringUtils.reverseSub(moduleName, 1, 7):lower() == ".shared" then

                module = module:Clone()
                module.Name = StringUtils.reverseSub(moduleName, 8)
                module.Parent = ServerModules

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

local Modules = ServerStorage:FindFirstChild("CardinalModules")
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