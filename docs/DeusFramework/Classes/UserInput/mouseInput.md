# MouseInput
*Inherited from [BaseObject](/DeusFramework/Classes/baseObject)*

!!! Warning "Client-only"

This is the replacement for Roblox's deprecated [Mouse](https://developer.roblox.com/en-us/api-reference/class/Mouse){target=blank} class.

## Enable

!!! warning "Internal Access Required"
    Re-connects internal connections to handle events.

    ```lua
    mouseInput:Enable()
    ```

## Disable

!!! warning "Internal Access Required"
    Disconnects internal connections to handle events.

    ```lua
    mouseInput:Disable()
    ```

## Events

All event callbacks have an [InputObject](https://developer.roblox.com/en-us/api-reference/class/InputObject){target=blank} as their first and only argument.

### Move

Fires when the mouse moves.

```lua
mouseInput.Move:Connect(function(inputObject)
    print("Move")
end)
```

### Button1Down

Fires when the left-mouse button is depressed.

```lua
mouseInput.Button1Down:Connect(function(inputObject)
    print("Button1Down")
end)
```

### Button1Up

Fires when the left-mouse button is raised.

```lua
mouseInput.Button1Up:Connect(function(inputObject)
    print("Button1Up")
end)
```

### Button2Down

Fires when the right-mouse button is depressed.

```lua
mouseInput.Button2Down:Connect(function(inputObject)
    print("Button2Down")
end)
```

### Button2Up

Fires when the right-mouse button is raised.

```lua
mouseInput.Button2Up:Connect(function(inputObject)
    print("Button2Up")
end)
```

### Button3Down

Fires when the middle-mouse button (scroll-wheel) is depressed.

```lua
mouseInput.Button3Down:Connect(function(inputObject)
    print("Button3Down")
end)
```

### Button3Up

Fires when the middle-mouse button (scroll-wheel) is raised.

```lua
mouseInput.Button3Up:Connect(function(inputObject)
    print("Button3Up")
end)
```

### WheelBackward

Fires when the scroll-wheel rolls backwards.

```lua
mouseInput.WheelBackward:Connect(function(inputObject)
    print("WheelBackward")
end)
```

### WheelForward

Fires when the scroll-wheel rolls forward.

```lua
mouseInput.WheelForward:Connect(function(inputObject)
    print("WheelForward")
end)
```