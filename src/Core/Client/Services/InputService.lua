local MouseInput
local KeyboardInput
local GamepadInput

local InputService = {}

function InputService.newMouseInput(...)
    return MouseInput.new(...)
end

function InputService.newKeyboardInput(...)
    return KeyboardInput.new(...)
end

function InputService.newGamepadInput(...)
    
end

function InputService:start()
    MouseInput = self:Load("Deus.MouseInput")
    KeyboardInput = self:Load("Deus.KeyboardInput")

    -- Allows all modules to use the same mouse object without needing to make new ones
    self.Mouse = MouseInput.new().Proxy
end

return InputService