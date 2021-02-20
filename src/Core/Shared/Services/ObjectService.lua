local Output
local InstanceUtils

local Objects = setmetatable({}, {__mode = "v"})

local ObjectService = {}

function ObjectService:GetObject(objectId)
    return Objects[objectId]
end

function ObjectService:GetObjectFromInstance(instance)
    instance = InstanceUtils.findFirstAncestorWithTag(instance, "DeusObject")

    Output.assert(instance, "Provided instance is not a DeusObject")

    return Objects[instance:GetAttribute("DEUS_ObjectId")]
end

function ObjectService:TrackObject(obj)
    Objects[obj.ObjectId] = obj
end

function ObjectService:start()
    Output = self:Load("Deus.Output")
    InstanceUtils = self:Load("Deus.InstanceUtils")
end

return ObjectService