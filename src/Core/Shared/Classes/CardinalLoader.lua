-- TODO: Refactor to new class convention

local Output
local BaseObject

local CardinalLoader = {}

local ReservedNames = {
    "Cardinal",
    "Deus"
}

local CardinalLoaderObjData = {
    ClassName = "CardinalLoader",

    Extendable = false,

    Methods = {

        Register = function(_, module, moduleName)
            moduleName = moduleName or module.Name
            Output.assert(not table.find(ReservedNames, moduleName), "Name '%s' is reserved and cannot be used to register a module", moduleName)
            CardinalLoader:Register(module, moduleName)
        end,

        Load = function(_, modulePath)
            return CardinalLoader:Load(modulePath)
        end,

        --[[
        IsRegistered = function(_, modulePath)
            return CardinalLoader:IsRegistered(modulePath)
        end
        ]]

    }
}

function CardinalLoader:start()
    Output = self:Load("Deus.Output")
    BaseObject = self:Load("Deus.BaseObject")

    return BaseObject.new(CardinalLoaderObjData)
end

return CardinalLoader