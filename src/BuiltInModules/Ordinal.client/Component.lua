local Component = {}

function Component.new()
    local self = {}

    return setmetatable(self, Component)
end

return Component