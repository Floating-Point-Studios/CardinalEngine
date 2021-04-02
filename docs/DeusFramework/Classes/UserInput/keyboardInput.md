# KeyboardInput
*Inherited from [BaseObject](/DeusFramework/Classes/baseObject)*

{client-only}

KeyboardInputs serve as a wrapper for a single [KeyCode](https://developer.roblox.com/en-us/api-reference/enum/KeyCode) they are easy to re-map as a result you should have a separate `KeyboardInput` for each action such as jumping, walking forwards, backwards, etc.

## Constructors

```lua
-- Example of a KeyboardInput for walking forward
local walkForward = KeyboardInput.new(Enum.KeyCode.W)

-- Example of a KeyboardInput for sprinting forward forward as it requires shift to be pressed for it to fire
local sprintForward = KeyboardInput.new(Enum.KeyCode.W, true)
```

## Enable
{internal}

Re-connects internal connections to handle events.

```lua
keyboardInput:Enable()
```

## Disable
{internal}

Disconnects internal connections to handle events.

```lua
keyboardInput:Disable()
```

## Events

All event callbacks have an [InputObject](https://developer.roblox.com/en-us/api-reference/class/InputObject){target=blank} as their first and only argument.

### Began

```lua
keyboardInput.Began:Connect(function(inputObject)
    print("KeyboardInput began")
end)
```

### Ended

```lua
keyboardInput.Began:Connect(function(inputObject)
    print("KeyboardInput ended")
end)
```

### Changed

```lua
keyboardInput.Began:Connect(function(inputObject)
    print("KeyboardInput changed")
end)
```

## Read-only Properties

| Name      | Description                                                           |
|           |                                                                       |
| Active    | `Boolean` tells if the user is currently pressing the required keys   |

## Read-write Properties

| Name      | Description                                                           |
|           |                                                                       |
| Shift     | `Boolean` decides if shift needs to be down for any events to fire    |
| KeyCode   | `Enum.KeyCode` KeyCode                                                |