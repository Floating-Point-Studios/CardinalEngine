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

        Register = function(_, _, module, moduleName)
            moduleName = moduleName or module.Name
            Output.assert(not table.find(ReservedNames, moduleName), "Name '%s' is reserved and cannot be used to register a module", moduleName)
            CardinalLoader:Register(module, moduleName)
        end,

        Load = function(_, _, modulePath)
            return CardinalLoader:Load(modulePath)
        end,

        --[[
        IsRegistered = function(_, _, modulePath)
            return CardinalLoader:IsRegistered(modulePath)
        end
        ]]

    }
}

function CardinalLoader.start()
    Output = CardinalLoader:Load("Deus.Output")
    BaseObject = CardinalLoader:Load("Deus.BaseObject")

    return BaseObject.new(CardinalLoaderObjData)
end

return CardinalLoader