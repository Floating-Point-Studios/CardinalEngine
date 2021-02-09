local ValidClasses = {
    "Frame",
    "ImageButton",
    "ImageLabel",
    "TextButton",
    "TextLabel",
    "ViewportFrame"
}

function __index(self, i)
    
end

function __newindex(self, i, v)
    
end

local Element = {}

function Element:TweenSize()
    
end

function Element:TweenPosition()
    
end

function Element:TweenSizeAndPosition()
    
end

function Element:TweenProperty()
    
end

function Element:Update()
    
end

function Element:IsA(className)
    return className == "OrdinalElement"
end

function Element:Destroy()
    
end

function Element.new(className)
    local self = {
        ClassName = "OrdinalElement",

        Hash = "",
        Parent = nil,
        Properties = {},
        Children = {},
    }

    return setmetatable(self, {__index = Element})
end

return Element