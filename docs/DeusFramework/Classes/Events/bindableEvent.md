# BindableEvent

An event object that behaves more similar to a Roblox object's event. This implementation also allows `userdata` types often made from `newproxy()` to be sent as arguments.

## new

Returns a new BindableEvent

```lua
local bindableEvent = BindableEvent.new()
```

## Connect

Returns a connection that can be disconnected

```lua
local connection = BindableEvent:Connect(function()

end)

connection:Disconnect()
```

## Wait

Returns the arguments the next time the event fires

```lua
local args = {BindableEvent:Wait()}
```

## Fire
{internal}

```lua
BindableEvent:Fire(...)
```