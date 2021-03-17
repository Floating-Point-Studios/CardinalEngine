local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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