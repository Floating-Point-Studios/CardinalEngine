local Output
local InstanceUtils

local Objects = setmetatable({}, {__mode = "v"})

local ObjectService = {}

function ObjectService:GetObject(objectId)
    return Objects[objectId]
end

--[[
function ObjectService:GetObjectFromInstance(instance)
    instance = InstanceUtils.findFirstAncestorWithTag(instance, "DeusObject")

    Output.assert(instance, "Provided instance is not a DeusObject")

    return Objects[instance:GetAttribute("DEUS_ObjectId")]
end
]]

--[[
function ObjectService:TrackObject(obj)
    Objects[obj.ObjectId] = obj
end
]]

function ObjectService:start()
    Output = self:Load("Deus.Output")
    InstanceUtils = self:Load("Deus.InstanceUtils")

    -- Hook into BaseObject and begin tracking
    self:Load("Deus.BaseObject").NewObject:Connect(function(obj)
        --self:TrackObject(objProxy)
        Objects[obj.ObjectId] = obj
    end)
end

return ObjectService