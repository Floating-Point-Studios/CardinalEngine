local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

-- Initialize Cardinal Client

local CardinalCore = script.Parent
local CardinalClient = CardinalCore.Client
local CardinalShared = CardinalCore.Shared

CardinalShared:Clone().Parent = CardinalClient
CardinalClient.Parent = ReplicatedFirst

-- Wait for Deus

repeat wait() until shared.Deus
local Deus = shared.Deus

local StringUtils = Deus:Load("Deus.StringUtils")

-- Intialize Cardinal Server

Deus:Register(script, "Cardinal")
Deus:Register(CardinalShared, "Cardinal")

shared.Cardinal = Deus:Load("Cardinal.CardinalLoader").new().Proxy
shared.Deus = nil

-- Sort Modules

local ServerPackages = Instance.new("Folder")
ServerPackages.Name = "CardinalPackages"

local ClientPackages = Instance.new("Folder")
ClientPackages.Name = "CardinalPackages"

local function SortModules(modules)
    for _,module in pairs(modules) do

		local moduleName = module.Name
		if module:IsA("Folder") or module:IsA("ModuleScript") then

            if moduleName:lower() == "server" then

                module = module:Clone()
                module.Name = module.Parent.Name
                module.Parent = ServerPackages

            elseif moduleName:lower() == "client" then

                module = module:Clone()
                module.Name = module.Parent.Name
                module.Parent = ClientPackages

            elseif moduleName:lower() == "shared" then

                module = module:Clone()
                module.Name = module.Parent.Name
                module.Parent = ServerPackages
                module:Clone().Parent = ClientPackages

            elseif StringUtils.reverseSub(moduleName, 1, 7):lower() == ".server" then

                module = module:Clone()
                module.Name = StringUtils.reverseSub(moduleName, 8)
                module.Parent = ServerPackages

            elseif StringUtils.reverseSub(moduleName, 1, 7):lower() == ".client" then

                module = module:Clone()
                module.Name = StringUtils.reverseSub(moduleName, 8)
                module.Parent = ClientPackages

            elseif StringUtils.reverseSub(moduleName, 1, 7):lower() == ".shared" then

                module = module:Clone()
                module.Name = StringUtils.reverseSub(moduleName, 8)
                module.Parent = ServerPackages

			else
				if module:IsA("ModuleScript") then
					module:Clone().Parent = ServerPackages
					module:Clone().Parent = ClientPackages
				else
					SortModules(module:GetChildren())
				end
            end

        elseif module:IsA("LocalScript") then
            module:Clone().Parent = ClientPackages
        elseif module:IsA("Script") then
            module:Clone().Parent = ServerPackages
        end

    end
end

local Modules = ServerStorage:FindFirstChild("CardinalPackages")
if Modules then
    SortModules(Modules:GetChildren())
end

ServerPackages.Parent = ServerScriptService
ClientPackages.Parent = ReplicatedStorage

-- Initialize Modules

for _,package in pairs(ServerPackages:GetChildren()) do
    if package:IsA("Folder") or package:IsA("ModuleScript") then
        Deus:Register(package)
    end
end