local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Initialize Cardinal

repeat wait() until shared.Deus
local Deus = shared.Deus

Deus:Register(script, "Cardinal")

shared.Cardinal = Deus:Load("Cardinal.CardinalLoader").new().Proxy
shared.Deus = nil

-- Initialize Modules

local Modules = ReplicatedStorage:WaitForChild("CardinalModules")

for _,module in pairs(Modules:GetChildren()) do
    Deus:Register(module)
end