local Deus

local Output

local ReservedNames = {
    "Cardinal",
    "Deus"
}

local CardinalLoader = {
    ClassName = "CardinalLoader",
    Extendable = false,
    Events = {}
}

function CardinalLoader:Register(module, moduleName)
    moduleName = moduleName or module.Name
    Output.assert(not table.find(ReservedNames, moduleName), "Name '%s' is reserved and cannot be used to register module", moduleName)
    Deus:Register(module, moduleName)
end

function CardinalLoader:Load(...)
    return Deus:Load(...)
end

function CardinalLoader:WrapModule(...)
    return Deus:WrapModule(...)
end

function CardinalLoader:IsRegistered(...)
    return Deus:IsRegistered(...)
end

function CardinalLoader:start()
    Deus = {
		Register = self.Register,
		Load = self.Load,
		WrapModule = self.WrapModule,
		IsRegistered = self.IsRegistered
	}

    Output = self:Load("Deus.Output")

    self.PrivateProperties = {}

    self.PublicReadOnlyProperties = {}

    self.PublicReadAndWriteProperties = {}

    return self:Load("Deus.BaseObject").new(self)
end

return CardinalLoader