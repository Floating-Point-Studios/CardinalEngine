# RemoteFunction
*Inherited from [BaseObject](/DeusFramework/Classes/baseObject)*

## new

When used on the Server the 1st argument should be the RemoteEvent's name, the 2nd argument is the parent

```lua
local remoteFunction = RemoteFunction.new("RemoteFunctionName", workspace)
```

When used on the Client the only argument should be a Roblox RemoteEvent instance

```lua
local remoteFunction = RemoteFunction.new(workspace.RemoteFunctionName)
```

## OnInvoke

!!! warning "Internal Access Required"
    When used on the Server this behaves like `OnServerInvoke()` and when used on the Client it behaves like `OnClientInvoke()`

    ```lua
    remoteFunction:OnInvoke(function(...)
        -- On the server this would return the player
        return {...}[1]
    end
    ```

## Invoke

When used on the Server this behaves like `InvokeClient()` and when used on the Client it behaves like `InvokeServer()`

```lua
-- Server
local result = remoteFunction:Invoke(player, ...)
```

```lua
-- Client
local result = remoteFunction:Invoke(...)
```