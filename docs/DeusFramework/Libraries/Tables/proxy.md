# Proxy

Userdata constructor similar to `newproxy()`

## new

```lua
-- Creates a userdata with the index "foo" equal to "bar"
local userdata = Proxy.new(
    {
        foo = "bar"
    },
    {
        -- Set metamethods here
    }
)
```

## Metamethods

!!! warning
    The metamethods `__eq`, `__lt`, and `__le` do not work

These metamethods can be set in the 2nd argument of `Proxy.new()`

| Name          |
|               |
| __metatable   |
| __index       |
| __newindex    |
| __tostring    |
| __call        |
| __concat      |
| __unm         |
| __add         |
| __sub         |
| __mul         |
| __div         |
| __mod         |
| __pow         |
| __len         |

For more details refer to the [Developer Hub](https://developer.roblox.com/en-us/articles/Metatables){target=blank}