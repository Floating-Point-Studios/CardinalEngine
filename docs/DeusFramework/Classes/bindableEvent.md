# BindableEvent

An event object that behaves more similar to a Roblox object's event. This implementation also allows `userdata` types often made from `newproxy()` to be sent as arguments.

## Usage

```lua
local bindableEvent = Deus:Load("Deus.BindableEvent").new()
```

## Methods

### Fire

!!! warning "Internal Access Required"

```lua
bindableEvent:Fire(...)
```

### Connect

```lua
bindableEvent:Connect(function(...)

end)
```

### Wait

```lua
local args = {bindableEvent:Wait()}
```

## Properties