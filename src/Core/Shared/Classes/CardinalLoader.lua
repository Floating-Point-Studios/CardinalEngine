local Deus = shared.Deus()

local Output = Deus:Load("Deus.Output")
local BaseObject = Deus:Load("Deus.BaseObject")

local ReservedNames = {
    "Cardinal",
    "Deus"
}

return BaseObject.new(
    {
        ClassName = "CardinalLoader",

        Extendable = false,

        Methods = {

            Register = function(self, internalAccess, module, moduleName)
                moduleName = moduleName or module.Name
                Output.assert(not table.find(ReservedNames, moduleName), "Name '%s' is reserved and cannot be used to register a module", moduleName)
                Deus:Register(module, moduleName)
            end,

            Load = function(self, internalAccess, modulePath)
                return Deus:Load(modulePath)
            end,

            IsRegistered = function(self, internalAccess, modulePath)
                return Deus:IsRegistered(modulePath)
            end

        }
    }
)