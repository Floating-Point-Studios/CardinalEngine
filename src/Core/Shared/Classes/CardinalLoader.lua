local Deus

local Output

local ReservedNames = {
    "Cardinal",
    "Deus"
}

local CardinalLoader = {
    ClassName = "CardinalLoader",
    Extendable = false,
    Replicable = false,
    Methods = {},
    Events = {}
}

function CardinalLoader:Constructor()
    Deus = getmetatable(self)
end

function CardinalLoader.Methods:Register(module, moduleName)
    moduleName = moduleName or module.Name
    Output.assert(not table.find(ReservedNames, moduleName), "Name '%s' is reserved and cannot be used to register module", moduleName)
    Deus:Register(module, moduleName)
end

function CardinalLoader.Methods:Load(...)
    return Deus:Load(...)
end

function CardinalLoader.Methods:WrapModule(...)
    return Deus:WrapModule(...)
end

function CardinalLoader.Methods:IsRegistered(...)
    return Deus:IsRegistered(...)
end

function CardinalLoader:start()
    Output = self:Load("Deus.Output")

    self.PrivateProperties = {}

    self.PublicReadOnlyProperties = {}

    self.PublicReadAndWriteProperties = {}

    return self:Load("Deus.BaseObject").new(self)
end

return CardinalLoader