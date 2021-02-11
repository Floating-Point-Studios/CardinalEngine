local Output
local Symbol
local BaseObject
local InstanceUtils

local ValidClasses = {
    "Frame",
    "ImageButton",
    "ImageLabel",
    "TextButton",
    "TextLabel",
    "ViewportFrame"
}

local ElementObjData = {
    ClassName = "OrdinalElement",

    Extendable = false,

    Replicable = false,

    Constructor = function(self, className, properties, parent)
        Output.assert(table.find(ValidClasses, className), "Class '%s' is not a valid element", className)

        if parent then
            self.Internal.DEUSOBJECT_LockedTables.ReadAndWriteProperties.Parent = parent
        end

        self.Internal.DEUSOBJECT_Properties.UIObject = InstanceUtils.make(
            {
                className,
                properties
            }
        )

        self.Internal.DEUSOBJECT_LockedTables.Events.Changed:Connect(function(propertyName, newValue, oldValue)
            if propertyName == "Parent" then
                
            end
        end)
    end,

    Methods = {},

    Events = {"Changed"},

    PrivateProperties = {
        InTween = false,
        UIObject = nil,
    },

    PublicReadOnlyProperties = {
        Children = {}
    },

    PublicReadAndWriteProperties = {
        Parent = Symbol.new("None"),
        Properties = {}
    }
}

local Element = {}

function Element.start()
    Output = Element:Load("Deus.Output")
    Symbol = Element:Load("Deus.Symbol")
    BaseObject = Element:Load("Deus.BaseObject")
    InstanceUtils = Element:Load("Deus.InstanceUtils")

    return BaseObject.new(ElementObjData)
end

return Element