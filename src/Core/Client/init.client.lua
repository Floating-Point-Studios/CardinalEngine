local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Initialize Cardinal

repeat wait() until shared.Deus
local Deus = shared.Deus

Deus:Register(script, "Cardinal")

shared.Cardinal = Deus:Load("Cardinal.CardinalLoader").new().Proxy
shared.Deus = nil

-- Initialize Packages

local Packages = ReplicatedStorage:WaitForChild("CardinalPackages")

for _,package in pairs(Packages:GetChildren()) do
    if package:IsA("LocalScript") then
        package.Parent = ReplicatedFirst
    elseif package:IsA("ModuleScript") then
        Deus:Register(package)
    end
end

-- Enable Roact Debugging
if RunService:IsStudio() then
    Deus:Load("Cardinal.Roact").setGlobalConfig(
        {
            typeChecks = true,
            internalTypeChecks = true,
            elementTracing = true,
            propValidation = true
        }
    )
end

-- Initalize ALICE
local ALICE = Deus:Load("Cardinal.ALICE").new()